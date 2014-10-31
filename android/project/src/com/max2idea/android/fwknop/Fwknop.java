/*****************************************************************************
 *
 * File:    Fwknop.java
 *
 * Purpose: A JNI wrapper for Damien Stuart's implementation of fwknop client
 *
 *  Fwknop is developed primarily by the people listed in the file 'AUTHORS'.
 *  Copyright (C) 2009-2014 fwknop developers and contributors. For a full
 *  list of contributors, see the file 'CREDITS'.
 *
 *  License (GNU General Public License):
 *
 *     This program is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with this program; if not, write to the Free Software
 *     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
 *     USA
 *
 *****************************************************************************
 */
package com.max2idea.android.fwknop;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;

import android.app.AlertDialog;
import android.content.ComponentName;
import android.widget.TextView;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.nfc.NdefMessage;
import android.nfc.NdefRecord;
import android.nfc.NfcAdapter;
import android.os.Handler;
import android.os.Message;
import android.os.Parcelable;
import android.preference.PreferenceManager;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.Toast;
import java.util.Arrays;
import java.util.List;

public class Fwknop extends Activity {

    public TextView mOutput;
    private boolean startApp = true;
    public Activity activity = this;

//    Generic Dialog box
    public static void UIAlert(String title, String body, Activity activity) {
        AlertDialog ad;
        ad = new AlertDialog.Builder(activity).create();
        ad.setTitle(title);
        ad.setMessage(body);
        ad.setButton("OK", new DialogInterface.OnClickListener() {

            public void onClick(DialogInterface dialog, int which) {
            }
        });
        ad.show();
    }
    private String output;
    private EditText mAllowip;
    private EditText mPasswd;
    private EditText mHmac;
    private EditText mDestip;
    private EditText mTCPAccessPorts;
    private EditText mUDPAccessPorts;
    private EditText mFwTimeout;
    private ImageButton mUnlock;
    private String access_str;
    private String allowip_str;
    private String passwd_str;
    private String hmac_str;
    private String destip_str;
    private String fw_timeout_str;
    private CheckBox mCheck;
    private int SPA_SENT = 1003;

    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        //Installer
        installNativeLibs();

        //Setup UI
        this.setContentView(R.layout.main);
        this.setupWidgets();
    }
  
    @Override
    public void onResume() {
        super.onResume();
        // Check to see that the Activity started due to an Android Beam
        Intent intent = getIntent();
        if(NfcAdapter.ACTION_NDEF_DISCOVERED.equals(intent.getAction())) {
            Parcelable[] rawMsgs = intent.getParcelableArrayExtra(NfcAdapter.EXTRA_NDEF_MESSAGES);
            NdefMessage msg = null;
            if (rawMsgs != null && rawMsgs.length > 0) {
                msg = (NdefMessage) rawMsgs[0];

                NdefRecord[] contentRecs = msg.getRecords();
                for (NdefRecord rec : contentRecs) {
                    if (rec.getTnf() == NdefRecord.TNF_WELL_KNOWN &&
                            Arrays.equals(rec.getType(),  NdefRecord.RTD_TEXT)) {

                        byte[] payload = rec.getPayload();

                        try {
                          //Get the Text Encoding
                          String textEncoding = ((payload[0] & 0200) == 0) ? "UTF-8" : "UTF-16";

                          //Get the Language Code
                          int languageCodeLength = payload[0] & 0077;
                          String languageCode = new String(payload, 1, languageCodeLength, "US-ASCII");

                          //Get the Text
                          String text = new String(payload, languageCodeLength + 1, payload.length - languageCodeLength - 1, textEncoding);

                          if (text.equals("fwknop"))
                            onStartButton();
                        } catch (Exception e) {
                          Toast.makeText(this, "NFC Tag parsing error", Toast.LENGTH_LONG).show();
                        }
                    }
                }
            }
            finish();
        }
    }

    public void sendSPA() {
        startSPASend();
    }

//    Intent for ConnectBot kickoff
    private void startApp() {
        Intent i = new Intent(Intent.ACTION_RUN);
        i.setComponent(new ComponentName("org.connectbot", "org.connectbot.HostListActivity"));
        PackageManager p = this.getPackageManager();
        List list = p.queryIntentActivities(i, PackageManager.COMPONENT_ENABLED_STATE_DEFAULT);
        if (list.isEmpty()) {
            Log.v("SPA", "ConnectBot is not installed");
            Toast.makeText(this, "ConnectBot is not installed", Toast.LENGTH_LONG).show();
        } else {
            Log.v("SPA", "Starting connectBot");
            Toast.makeText(this, "Starting ConnectBot", Toast.LENGTH_LONG).show();
            startActivity(i);
        }
    }
    // Define the Handler that receives messages from the thread and update the progress
    public Handler handler = new Handler() {

        @Override
        public synchronized void handleMessage(Message msg) {
            Bundle b = msg.getData();
            Integer messageType = (Integer) b.get("message_type");
            if (messageType != null && messageType == SPA_SENT) {
                Toast.makeText(activity, output, Toast.LENGTH_LONG).show();
            }

        }
    };

//    Another Generic Messanger
    public static void sendHandlerMessage(Handler handler, int message_type) {
        Message msg1 = handler.obtainMessage();
        Bundle b = new Bundle();
        b.putInt("message_type", message_type);
        msg1.setData(b);
        handler.sendMessage(msg1);
    }

//   Main event function
//    Retrieves values from saved preferences
    private void onStartButton() {


        SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(this);
        SharedPreferences.Editor edit = prefs.edit();
//
        this.access_str = "";
        if (this.mTCPAccessPorts != null) {
            if(!this.mTCPAccessPorts.getText().toString().equals("")){
                String[] ports = this.mTCPAccessPorts.getText().toString().split(",");
                for(int i = 0; i < ports.length; i++){
                    try {
                        int port = Integer.parseInt(ports[i]);
                        if(i > 0)
                            this.access_str = this.access_str + ",";
                        this.access_str = this.access_str + "tcp/" + port;
                    } catch (Exception e) {
                        UIAlert("Input error", ports[i] + " is not a valid port number", this);
                        return;
                    }
                }
            }
            edit.putString("tcpAccessPorts_str", mTCPAccessPorts.getText().toString());
        }

        if (this.mUDPAccessPorts != null) {
            if(!this.mUDPAccessPorts.getText().toString().equals("")){
                String[] ports = this.mUDPAccessPorts.getText().toString().split(",");
                for(int i = 0; i < ports.length; i++){
                    try {
                        int port = Integer.parseInt(ports[i]);
                        if(this.access_str != null && !this.access_str.equals(""))
                            this.access_str = this.access_str + ",";
                        this.access_str = this.access_str + "udp/" + port;
                    } catch (Exception e) {
                        UIAlert("Input error", ports[i] + " is not a valid port number", this);
                        return;
                    }
                }
            }
            edit.putString("udpAccessPorts_str", mUDPAccessPorts.getText().toString());
        }

        if(this.access_str.equals("")){
            UIAlert("Input error", "Please enter a TCP or UDP port", this);
            return;
        }
        
        if (this.mAllowip != null) {
            if(this.mAllowip.getText().toString().equals("")) {
                this.allowip_str = "";
            } else {
                this.allowip_str = mAllowip.getText().toString().trim();
            }

            edit.putString("allowip_str", allowip_str);
        } else {
            UIAlert("Input error", "Please use a valid IP address", this);
            return;
        }

        if (this.mPasswd != null && !this.mPasswd.getText().toString().trim().equals("")) {
            this.passwd_str = mPasswd.getText().toString();
            edit.putString("passwd_str", mPasswd.getText().toString());
        } else {
            UIAlert("Input error", "Please enter a key", this);
            return;
        }

        if (this.mHmac != null && !this.mHmac.getText().toString().trim().equals("")) {
            this.hmac_str = mHmac.getText().toString();
            edit.putString("hmac_str", mHmac.getText().toString());
        } else {
            // the HMAC is currently optional
            this.hmac_str = "";
            edit.putString("hmac_str", this.hmac_str);
        }

        if (this.mDestip != null && !this.mDestip.getText().toString().trim().equals("")) {
            this.destip_str = mDestip.getText().toString();
            edit.putString("destip_str", mDestip.getText().toString());
        } else {
            UIAlert("Input error", "Please enter a valid Server address", this);
            return;
        }

        if (this.mFwTimeout != null) {
            try {
                Integer.parseInt(this.mFwTimeout.getText().toString());
            } catch (Exception e) {
                UIAlert("Input error", "Please enter a valid timeout value", this);
                return;
            }
            this.fw_timeout_str = mFwTimeout.getText().toString();
            edit.putString("fw_timeout_str", mFwTimeout.getText().toString());
        }

        this.startApp = (this.mCheck != null && this.mCheck.isChecked());

        edit.putBoolean("app_start", startApp);
        edit.commit();

        this.sendSPA();
    }

//    Setting up the UI
    public void setupWidgets() {

        SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(this);
        this.mTCPAccessPorts = (EditText) findViewById(R.id.tcpAccessPorts);
        this.mTCPAccessPorts.setText(prefs.getString("tcpAccessPorts_str", "22"));
        this.mUDPAccessPorts = (EditText) findViewById(R.id.udpAccessPorts);
        this.mUDPAccessPorts.setText(prefs.getString("udpAccessPorts_str", ""));

        this.mAllowip = (EditText) findViewById(R.id.allowip);
        this.mAllowip.setText(prefs.getString("allowip_str", ""));

        this.mDestip = (EditText) findViewById(R.id.destIP);
        this.mDestip.setText(prefs.getString("destip_str", ""));

        this.mFwTimeout = (EditText) findViewById(R.id.fwTimeout);
        this.mFwTimeout.setText(prefs.getString("fw_timeout_str", "60"));

        this.mCheck = (CheckBox) findViewById(R.id.startAppCheck);
        this.mCheck.setChecked(prefs.getBoolean("app_start", false));

        this.mPasswd = (EditText) findViewById(R.id.passwd);
        this.mPasswd.setText(prefs.getString("passwd_str", ""));

        this.mOutput = (TextView) findViewById(R.id.output);

        this.mHmac   = (EditText) findViewById(R.id.hmac);
        this.mHmac.setText(prefs.getString("hmac_str", ""));

        mUnlock = (ImageButton) findViewById(R.id.unlock);
        mUnlock.setOnClickListener(new OnClickListener() {

            public void onClick(View view) {
                onStartButton();

            }
        });


    }

    public native String sendSPAPacket();

    @Override
    public void onStop() {
        super.onStop();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
    }

    private void installNativeLibs() {
        //Installation of C libs during apk installation, manual installation is not needed anymore
//        installNativeLib("libfwknop.so", "/data/data/com.max2idea.android.fwknop/lib");

        //Load the C library
        loadNativeLib("libfwknop.so", getFilesDir().getPath() + "/../lib");
    }

//    Load the shared lib
    private void loadNativeLib(String lib, String destDir) {
        String libLocation = destDir + "/" + lib;
        try {
            System.load(libLocation);
        } catch (Exception ex) {
            Log.e("JNIExample", "failed to load native library: " + ex);
        }

    }

//    Start calling the JNI interface
    public synchronized void startSPASend() {
        output = sendSPAPacket();
        sendHandlerMessage(handler, SPA_SENT);
        if (startApp) {
            startApp();
        }
    }
}
