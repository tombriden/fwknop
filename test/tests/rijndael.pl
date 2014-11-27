@rijndael = (
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'complete cycle (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline'  => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => '3 cycles (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline'  => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
        'client_cycles_per_server_instance' => 3,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'short IP 1.1.1.1 (ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => "$fwknopCmd -A tcp/22 -a 1.1.1.1 -D $loopback_ip --get-key " .
            "$local_key_file --no-save-args $verbose_str",
        'fwknopd_cmdline'  => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
        'no_ip_check' => 1
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'long IP 123.123.123.123 (ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => "$fwknopCmd -A tcp/22 -a 123.123.123.123 -D $loopback_ip --get-key " .
            "$local_key_file --no-save-args $verbose_str",
        'fwknopd_cmdline'  => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
        'no_ip_check' => 1
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'complete cycle legacy truncated key',
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args_long_key -M legacy",
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'legacy_iv_long_key_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'use of encryption key with fd 0',
        'function' => \&spa_cycle,
        'cmdline'  => "echo $local_spa_key | $default_client_args_no_get_key " .
            "--fd 0",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'use of encryption key with stdin',
        'function' => \&spa_cycle,
        'cmdline'  => "echo $local_spa_key | $default_client_args_no_get_key " .
            "--stdin",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'localhost hostname->IP (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => "$fwknopCmd -A tcp/22 -a $fake_ip -D localhost --get-key " .
            "$local_key_file --no-save-args $verbose_str",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'rotate digest file',
        'function' => \&rotate_digest_file,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str --rotate-digest-cache",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client',
        'detail'   => "--save-packet $tmp_pkt_file",
        'function' => \&client_save_spa_pkt,
        'cmdline' => "$fwknopCmd -A tcp/22 -a $fake_ip -D $loopback_ip --get-key " .
            "$local_key_file --save-args-file $tmp_args_file $verbose_str " .
            "--save-packet $tmp_pkt_file",
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client',
        'detail'   => "--last-cmd",
        'function' => \&run_last_args,
        'cmdline'  => "$fwknopCmd --last-cmd --save-args-file $tmp_args_file -v -v -v"
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'permissions check cycle (tcp/22)',
        'function' => \&permissions_check,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'server_positive_output_matches' => [qr/permissions\sshould\sonly\sbe\suser/],
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'SPA through HTTP proxy',
        'function' => \&generic_exec,
        'cmdline'  => "$default_client_args -H $resolve_url_with_port --test",
        'no_ip_check' => 1,
        'fw_rule_created' => $REQUIRE_NO_NEW_RULE,
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'client IP resolve (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => $client_ip_resolve_args,
        'no_ip_check' => 1,
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'client IP --resolve-url <def>',
        'function' => \&spa_cycle,
        'cmdline'  => "$client_ip_resolve_args " .
            "--resolve-url https://www.cipherdyne.org/cgi-bin/myip",
        'no_ip_check' => 1,
        'positive_output_matches' => [qr/wget/],
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'client IP --resolve-http-only',
        'function' => \&spa_cycle,
        'cmdline'  => "$client_ip_resolve_args --resolve-http-only",
        'no_ip_check' => 1,
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'client IP resolve manual URL',
        'function' => \&spa_cycle,
        'cmdline'  => "$client_ip_resolve_args --resolve-url $resolve_url",
        'no_ip_check' => 1,
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'client IP resolve URL with port',
        'function' => \&spa_cycle,
        'cmdline'  => "$client_ip_resolve_args --resolve-url $resolve_url_with_port",
        'no_ip_check' => 1,
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client',
        'detail'   => 'client IP --resolve-http-only vs HTTPS',
        'function' => \&generic_exec,
        'cmdline'  => "$client_ip_resolve_args --resolve-http-only " .
            "--resolve-url https://somedomain.com/myip",
        'no_ip_check' => 1,
        'positive_output_matches' => [qr/not.*supported/i],
        'fw_rule_created' => $REQUIRE_NO_NEW_RULE,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client',
        'detail'   => 'client IP resolve invalid port',
        'function' => \&generic_exec,
        'cmdline'  => "$client_ip_resolve_args --resolve-url http://somedomain.com:99999/myip",
        'no_ip_check' => 1,
        'positive_output_matches' => [qr/port.*invalid/i],
        'fw_rule_created' => $REQUIRE_NO_NEW_RULE,
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'complete cycle MD5 (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args -m md5",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'complete cycle SHA1 (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args -m sha1",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'complete cycle SHA256 (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args -m sha256",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'complete cycle SHA384 (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args -m sha384",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'complete cycle SHA512 (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args -m sha512",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client->server compatibility',
        'detail'   => 'Cygwin Windows 2008',
        'function' => \&backwards_compatibility,
        'no_ip_check' => 1,
        'pkt' =>
            '8GuHEQbyE4TuEbP7zL2DVsTbQv8x3jp8mdHFM0v+9ZUfgZMjuZLBvAa8NnmUdAb' .
            '/OUvCP5PFDVbLDnZ+JYUFMGexGRwlk5CEKX8KA8R1Xh5xIdbVxWzy1lY1imRQD5' .
            'wpIBx/hGB4O2G3mdJSe3w5zxGjE2JNSFKCAZzvgDmfLQM9A+tjMKPk6x',
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'disable_aging'} -a $cf{'def_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_positive_output_matches' => [qr/with expire time/],
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => "$FW_TYPE - no flush at init",
        'function' => \&iptables_no_flush_init_exit,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline' => qq/$fwknopdCmd -c $cf{"${fw_conf_prefix}_no_flush_init"} -a $cf{'def_access'} / .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_positive_output_matches' => [
            qr/\'\schain exists/,
            qr/^2\s+ACCEPT.*$fake_ip\s.*dpt\:22/,
        ],
        'insert_rule_before_exec' => $YES,
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => "$FW_TYPE - no flush at exit",
        'function' => \&iptables_no_flush_init_exit,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline' => qq/$fwknopdCmd -c $cf{"${fw_conf_prefix}_no_flush_exit"} -a $cf{'def_access'} / .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_positive_output_matches' => [
            qr/\'\schain exists/,
            qr/^2\s+ACCEPT.*$fake_ip\s.*dpt\:22/,
        ],
        'insert_rule_while_running'  => $YES,
        'search_for_rule_after_exit' => $YES,
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => "$FW_TYPE - no flush at init or exit",
        'function' => \&iptables_no_flush_init_exit,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline' => qq/$fwknopdCmd -c $cf{"${fw_conf_prefix}_no_flush_init_or_exit"} -a $cf{'def_access'} / .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_positive_output_matches' => [
            qr/\'\schain exists/,
            qr/^2\s+ACCEPT.*$fake_ip\s.*dpt\:22/,
        ],
        'insert_rule_before_exec'    => $YES,
        'search_for_rule_after_exit' => $YES,
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client',
        'detail'   => 'validate digest type arg',
        'function' => \&generic_exec,
        'cmdline'  => "$default_client_args -m invaliddigest",
        'positive_output_matches' => [qr/Invalid\sdigest\stype/i],
        'fw_rule_created' => $REQUIRE_NO_NEW_RULE,
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'dual usage access key (tcp/80 http)',
        'function' => \&spa_cycle,
        'cmdline'  => "$fwknopCmd -A tcp/80 -a $fake_ip -D $loopback_ip --get-key " .
            "$local_key_file $verbose_str",
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'dual_key_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        ### check for the first stanza that does not allow tcp/80 - the
        ### second stanza allows this
        'server_positive_output_matches' => [qr/stanza #1\)\sOne\sor\smore\srequested\sprotocol\/ports\swas\sdenied/],
        'weak_server_receive_check' => $YES,
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'create rc file (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args --rc-file $tmp_rc_file",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
        'key_file' => $tmp_rc_file,
    },
    {
        'category' => 'basic operations',
        'subcategory' => 'client',
        'detail'   => "rc file created",
        'function' => \&rc_file_exists,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'rc file default key (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args_no_get_key " .
            "--rc-file $cf{'rc_def_key'}",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
        'key_file' => $cf{'rc_def_key'},
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'rc file base64 key (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args_no_get_key " .
            "--rc-file $cf{'rc_def_b64_key'}",
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'base64_key_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
        'key_file' => $cf{'rc_def_b64_key'},
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'rc file named key (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args_no_get_key " .
            "--rc-file $cf{'rc_named_key'} -n testssh",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
        'key_file' => $cf{'rc_named_key'},
    },

    ### --key-gen tests
    {
        'category' => 'Rijndael',
        'subcategory' => 'client',
        'detail'   => '--key-gen',
        'function' => \&generic_exec,
        'cmdline'  => "$fwknopCmd --key-gen",
        'positive_output_matches' => [qr/^KEY_BASE64\:?\s\S{10}/,
            qw/HMAC_KEY_BASE64\:?\s\S{10}/],
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client',
        'detail'   => "--key-gen $uniq_keys key uniqueness",
        'function' => \&key_gen_uniqueness,
        'cmdline'  => "$fwknopCmd --key-gen",   ### no valgrind string (too slow for 100 client exec's)
        'disable_valgrind' => $YES,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client',
        'detail'   => '--key-gen to file',
        'function' => \&generic_exec,
        'cmdline'  => "$fwknopCmd --key-gen --key-gen-file $key_gen_file",
        'positive_output_matches' => [qr/Wrote.*\skeys/],
    },

    ### rc file tests
    {
        'category' => 'Rijndael',
        'subcategory' => 'client',
        'detail'   => 'rc file invalid stanza (tcp/22 ssh)',
        'function' => \&generic_exec,
        'cmdline'  => "$default_client_args_no_get_key " .
            "--rc-file $cf{'rc_named_key'} -n invalidstanza",
        'positive_output_matches' => [qr/Named\sconfiguration.*not\sfound/],
        'key_file' => $cf{'rc_named_key'},
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client',
        'detail'   => 'rc file invalid base64 key (tcp/22 ssh)',
        'function' => \&generic_exec,
        'cmdline'  => "$default_client_args_no_get_key " .
            "--rc-file $cf{'rc_invalid_b64_key'} -n testssh",
        'positive_output_matches' => [qr/look\slike\sbase64\-encoded/],
        'key_file' => $cf{'rc_invalid_b64_key'},
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'packet aging (past) (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args --time-offset-minus 300s",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'server_positive_output_matches' => [qr/SPA\sdata\stime\sdifference/],
        'fw_rule_created' => $REQUIRE_NO_NEW_RULE,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'packet aging (future) (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args --time-offset-plus 300s",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'server_positive_output_matches' => [qr/SPA\sdata\stime\sdifference/],
        'fw_rule_created' => $REQUIRE_NO_NEW_RULE,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'invalid SOURCE (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'invalid_src_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_positive_output_matches' => [qr/Fatal\serror\sparsing\sIP\sto\sint/],
        'server_exec_err' => $YES,
        'fw_rule_created' => $REQUIRE_NO_NEW_RULE,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'expired stanza (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'exp_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_positive_output_matches' => [qr/Access\sstanza\shas\sexpired/],
        'fw_rule_created' => $REQUIRE_NO_NEW_RULE,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'invalid expire date (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'invalid_exp_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_positive_output_matches' => [qr/invalid\sdate\svalue/],
        'fw_rule_created' => $REQUIRE_NO_NEW_RULE,
        'server_exec_err' => $YES,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'expired epoch stanza (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'exp_epoch_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_positive_output_matches' => [qr/Access\sstanza\shas\sexpired/],
        'fw_rule_created' => $REQUIRE_NO_NEW_RULE,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'future expired stanza (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'future_exp_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'OPEN_PORTS (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'open_ports_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'OPEN_PORTS mismatch',
        'function' => \&spa_cycle,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'open_ports_mismatch'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_positive_output_matches' => [qr/One\s+or\s+more\s+requested/],
        'fw_rule_created' => $REQUIRE_NO_NEW_RULE,
    },

    ### spoof the source IP on the SPA packet
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => "udpraw spoof src IP (tcp/22 ssh)",
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args -P udpraw -Q $spoof_ip",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
        'server_positive_output_matches' => [qr/SPA\sPacket\sfrom\sIP\:\s$spoof_ip\s/],
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => "tcpraw spoof src IP (tcp/22 ssh)",
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args -P tcpraw -Q $spoof_ip",
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'tcp_pcap_filter'} -a $cf{'def_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
        'server_positive_output_matches' => [qr/SPA\sPacket\sfrom\sIP\:\s$spoof_ip\s/],
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => "icmp spoof src IP (tcp/22 ssh)",
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args -P icmp -Q $spoof_ip",
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'icmp_pcap_filter'} -a $cf{'def_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
        'server_positive_output_matches' => [qr/SPA\sPacket\sfrom\sIP\:\s$spoof_ip\s/],
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => "icmp type/code 8/0 spoof src IP",
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args -P icmp --icmp-type 8 --icmp-code 0 -Q $spoof_ip",
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'icmp_pcap_filter'} -a $cf{'def_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
        'server_positive_output_matches' => [qr/SPA\sPacket\sfrom\sIP\:\s$spoof_ip\s/],
    },

    ### SPA over TCP (not really "single" packet auth since a TCP connection
    ### is established)
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => "SPA over TCP connection",
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args -P tcp",
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'tcp_server'} -a $cf{'def_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => "UDP server --udp-server / tcp/22",
        'function' => \&spa_cycle,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline'  => "$fwknopdCmd $default_server_conf_args $intf_str --udp-server",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => "UDP server conf / tcp/22",
        'function' => \&spa_cycle,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'udp_server'} -a $cf{'def_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'require user (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => "SPOOF_USER=$spoof_user $default_client_args",
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'require_user_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'user mismatch (tcp/22 ssh)',
        'function' => \&user_mismatch,
        'function' => \&spa_cycle,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'user_mismatch_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_positive_output_matches' => [qr/Username\s+in\s+SPA\s+data/],
        'fw_rule_created' => $REQUIRE_NO_NEW_RULE,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'require src (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'require_src_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'mismatch require src (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => "$fwknopCmd -A tcp/22 -s -D $loopback_ip --get-key " .
            "$local_key_file $verbose_str",
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'require_src_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_positive_output_matches' => [qr/Got\s0.0.0.0\swhen\svalid\ssource\sIP/],
        'fw_rule_created' => $REQUIRE_NO_NEW_RULE,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'allow -s (tcp/22 ssh)',
        'no_ip_check' => 1,
        'function' => \&spa_cycle,
        'cmdline'  => "$fwknopCmd -A tcp/22 -s -D $loopback_ip --get-key " .
            "$local_key_file $verbose_str",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'IP filtering (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'no_src_match'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_positive_output_matches' => [qr/No\saccess\sdata\sfound/],
        'server_receive_re' => qr/No\saccess\sdata\sfound/,
        'weak_server_receive_check' => $YES,
        'fw_rule_created' => $REQUIRE_NO_NEW_RULE,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'subnet filtering (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'no_subnet_match'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_receive_re' => qr/No\saccess\sdata\sfound/,
        'weak_server_receive_check' => $YES,
        'fw_rule_created' => $REQUIRE_NO_NEW_RULE,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'IP+subnet filtering (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'no_multi_src'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_receive_re' => qr/No\saccess\sdata\sfound/,
        'weak_server_receive_check' => $YES,
        'fw_rule_created' => $REQUIRE_NO_NEW_RULE,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'IP match (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'ip_src_match'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'subnet match (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'subnet_src_match'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'multi IP/net match (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'multi_src_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'multi access stanzas (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'multi_stanza_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'bad/good key stanzas (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'broken_keys_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'weak_server_receive_check' => $YES,
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => "non-enabled NAT (tcp/22 ssh)",
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args -N $internal_nat_host:22",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'server_positive_output_matches' => [qr/requested\sNAT\saccess.*not\senabled/i],
        'server_conf' => $cf{'def'},
        'fw_rule_created' => $REQUIRE_NO_NEW_RULE,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => "NAT to $internal_nat_host (tcp/22 ssh)",
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args -N $internal_nat_host:22",
        'fwknopd_cmdline' => qq/$fwknopdCmd -c $cf{"${fw_conf_prefix}_nat"} -a $cf{'open_ports_access'} / .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_positive_output_matches' => [
            qr/FWKNOP_FORWARD\s.*dport\s22\s/,
            qr/\*\/\sto\:$internal_nat_host\:22/i],
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
        'server_conf' => $cf{"${fw_conf_prefix}_nat"},
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => "SNAT $internal_nat_host",
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args -N $internal_nat_host:22",
        'fwknopd_cmdline' => qq/$fwknopdCmd -c $cf{"${fw_conf_prefix}_snat"} -a $cf{'open_ports_access'} / .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_positive_output_matches' => [
            qr/FWKNOP_FORWARD\s.*dport\s22\s/,
            qr/\*\/\sto\:$internal_nat_host\:22/i],
        'no_ip_check' => 1,
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
        'server_conf' => $cf{"${fw_conf_prefix}_snat"},
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => "SNAT MASQUERADE",
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args -N $internal_nat_host:22",
        'fwknopd_cmdline' => qq/$fwknopdCmd -c $cf{"${fw_conf_prefix}_snat_no_translate_ip"} -a $cf{'open_ports_access'} / .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_positive_output_matches' => [
            qr/FWKNOP_FORWARD\s.*dport\s22\s/,
            qr/\*\/\sto\:$internal_nat_host\:22/i,
            qr/MASQUERADE\s.*to\-ports/,
        ],
        'no_ip_check' => 1,
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
        'server_conf' => $cf{"${fw_conf_prefix}_snat_no_translate_ip"},
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => "NAT hostname->IP (tcp/22 ssh)",
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args -N localhost:22",
        'fwknopd_cmdline' => qq/$fwknopdCmd -c $cf{"${fw_conf_prefix}_nat"} -a $cf{'open_ports_access'} / .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_positive_output_matches' => [
            qr/FWKNOP_FORWARD\s.*dport\s22\s/,
            qr/\*\/\sto\:127.0.0.1\:22/i],
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
        'server_conf' => $cf{"${fw_conf_prefix}_nat"},
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => "NAT tcp/80 to $internal_nat_host tcp/22",
        'function' => \&spa_cycle,
        'cmdline'  => "$fwknopCmd -A tcp/80 -a $fake_ip -D $loopback_ip --get-key " .
            "$local_key_file $verbose_str -N $internal_nat_host:22",
        'fwknopd_cmdline' => qq/$fwknopdCmd -c $cf{"${fw_conf_prefix}_nat"} -a $cf{'def_access'} / .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_positive_output_matches' => [
            qr/FWKNOP_FORWARD\s.*dport\s22\s/,
            qr/\*\/\sto\:$internal_nat_host\:22/i],
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
        'server_conf' => $cf{"${fw_conf_prefix}_nat"},
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client',
        'detail'   => "NAT bogus IP validation",
        'function' => \&generic_exec,
        'exec_err' => $YES,
        'cmdline'  => "$default_client_args -N 999.1.1.1:22",
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => "force NAT $force_nat_host (tcp/22 ssh)",
        'function' => \&spa_cycle,
        'cmdline'  => $default_client_args,
        'fwknopd_cmdline' => qq/$fwknopdCmd -c $cf{"${fw_conf_prefix}_nat"} -a $cf{'force_nat_access'} / .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_positive_output_matches' => [qr/\sto\:$force_nat_host\:22/i],
        'server_negative_output_matches' => [qr/\sto\:$internal_nat_host\:22/i],
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
        'server_conf' => $cf{"${fw_conf_prefix}_nat"},
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => "local NAT $force_nat_host (tcp/22 ssh)",
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args --nat-local",
        'fwknopd_cmdline' => qq/$fwknopdCmd -c $cf{"${fw_conf_prefix}_local_nat"} -a $cf{'force_nat_access'} / .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_positive_output_matches' => [qr/\*\/\sto\:$force_nat_host\:22/i,
            qr/FWKNOP_INPUT.*dport\s22.*\sACCEPT/],
        'server_negative_output_matches' => [qr/\*\/\sto\:$internal_nat_host\:22/i],
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
        'server_conf' => $cf{"${fw_conf_prefix}_local_nat"},
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => "local NAT hostname->IP (tcp/22 ssh)",
        'function' => \&spa_cycle,
        'cmdline'  => "$fwknopCmd -A tcp/22 -a $fake_ip -D localhost --nat-local " .
            "--get-key $local_key_file --no-save-args $verbose_str",
        'fwknopd_cmdline' => qq/$fwknopdCmd -c $cf{"${fw_conf_prefix}_local_nat"} -a $cf{'force_nat_access'} / .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_positive_output_matches' => [qr/\*\/\sto\:$force_nat_host\:22/i,
            qr/FWKNOP_INPUT.*dport\s22.*\sACCEPT/],
        'server_negative_output_matches' => [qr/\*\/\sto\:$internal_nat_host\:22/i],
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
        'server_conf' => $cf{"${fw_conf_prefix}_local_nat"},
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => "local NAT rand port to tcp/22",
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args --nat-local --nat-rand-port",
        'fwknopd_cmdline' => qq/$fwknopdCmd -c $cf{"${fw_conf_prefix}_local_nat"} -a $cf{'def_access'} / .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_positive_output_matches' => [qr|\s\*\/\sto\:$loopback_ip\:22|i,
            qr/FWKNOP_INPUT.*dport\s22.*\sACCEPT/],
        'server_negative_output_matches' => [qr/\*\/\sto\:$internal_nat_host\:22/i],
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
        'server_conf' => $cf{"${fw_conf_prefix}_local_nat"},
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => "NAT rand port to tcp/22",
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args --nat-rand-port -N $internal_nat_host",
        'fwknopd_cmdline' => qq/$fwknopdCmd -c $cf{"${fw_conf_prefix}_nat"} -a $cf{'def_access'} / .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_positive_output_matches' => [
            qr/FWKNOP_FORWARD.*dport\s22\s.*\sACCEPT/,
            qr/FWKNOP_PREROUTING.*\sDNAT\s.*to\-destination\s$internal_nat_host\:22/,
        ],
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
        'server_conf' => $cf{"${fw_conf_prefix}_nat"},
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => "NAT rand port to -N <host>:40001",
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args --nat-rand-port -N $internal_nat_host:40001",
        'fwknopd_cmdline' => qq/$fwknopdCmd -c $cf{"${fw_conf_prefix}_nat"} -a $cf{'def_access'} / .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_positive_output_matches' => [
            qr/FWKNOP_FORWARD.*dport\s40001\s.*\sACCEPT/,
            qr/FWKNOP_PREROUTING.*\sDNAT\s.*to\-destination\s$internal_nat_host\:40001/,
        ],
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
        'server_conf' => $cf{"${fw_conf_prefix}_nat"},
    },


    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => "local NAT non-FORCE_NAT (tcp/22)",
        'function' => \&spa_cycle,
        'cmdline'  => "$fwknopCmd -A tcp/22 -a $fake_ip -D $loopback_ip --get-key " .
            "$local_key_file $verbose_str --nat-local --nat-port 80",
        'fwknopd_cmdline' => qq/$fwknopdCmd -c $cf{"${fw_conf_prefix}_local_nat"} -a $cf{'def_access'} / .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_positive_output_matches' => [qr|\s\*\/\sto\:$loopback_ip\:22|i,
            qr/FWKNOP_INPUT.*dport\s22.*\sACCEPT/],
        'server_negative_output_matches' => [qr/\*\/\sto\:$internal_nat_host\:22/i],
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
        'server_conf' => $cf{"${fw_conf_prefix}_local_nat"},
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'ECB mode (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args -M ecb",
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'ecb_mode_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_negative_output_matches' => [qr/Decryption\sfailed/i],
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'CFB mode (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args -M cfb",
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'cfb_mode_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_negative_output_matches' => [qr/Decryption\sfailed/i],
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'CTR mode (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args -M ctr",
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'ctr_mode_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_negative_output_matches' => [qr/Decryption\sfailed/i],
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'OFB mode (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args -M ofb",
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'ofb_mode_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_negative_output_matches' => [qr/Decryption\sfailed/i],
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'mode mismatch (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args -M ecb",
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'def_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'server_positive_output_matches' => [qr/Decryption\sfailed/i],
        'fw_rule_created' => $REQUIRE_NO_NEW_RULE,
    },

    ### --pcap-file
    {
        'category' => 'Rijndael',
        'subcategory' => 'server',
        'detail'   => '--pcap-file processing',
        'function' => \&process_pcap_file_directly,
        'cmdline'  => '',
        'fwknopd_cmdline' => "$fwknopdCmd -c $cf{'def'} -a $cf{'legacy_iv_access'} " .
            "-d $default_digest_file -p $default_pid_file " .
            "--pcap-file $replay_pcap_file --foreground $verbose_str --verbose",
        'server_positive_output_matches' => [qr/Replay\sdetected/i,
            qr/candidate\sSPA/, qr/0x0000\:\s+2b/],
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'complete cycle (tcp/23 telnet)',
        'function' => \&spa_cycle,
        'cmdline' => "$fwknopCmd -A tcp/23 -a $fake_ip -D $loopback_ip --get-key " .
            "$local_key_file $verbose_str",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'complete cycle (tcp/9418 git)',
        'function' => \&spa_cycle,
        'cmdline' => "$fwknopCmd -A tcp/9418 -a $fake_ip -D $loopback_ip --get-key " .
            "$local_key_file $verbose_str",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'complete cycle (tcp/60001)',
        'function' => \&spa_cycle,
        'cmdline' => "$fwknopCmd -A tcp/60001 -a $fake_ip -D $loopback_ip --get-key " .
            "$local_key_file $verbose_str",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'multi port (tcp/60001,udp/60001)',
        'function' => \&spa_cycle,
        'cmdline' => "$fwknopCmd -A tcp/60001,udp/60001 -a $fake_ip -D $loopback_ip --get-key " .
            "$local_key_file $verbose_str",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'multi port (tcp/22,udp/53,tcp/1234)',
        'function' => \&spa_cycle,
        'cmdline' => "$fwknopCmd -A tcp/22,udp/53,tcp/1234 -a $fake_ip -D $loopback_ip --get-key " .
            "$local_key_file $verbose_str",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'complete cycle (udp/53 dns)',
        'function' => \&spa_cycle,
        'cmdline' => "$fwknopCmd -A udp/53 -a $fake_ip -D $loopback_ip --get-key " .
            "$local_key_file $verbose_str",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => "-P bpf SPA over port $non_std_spa_port",
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args --server-port $non_std_spa_port",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str " .
            qq|-P "udp port $non_std_spa_port"|,
        'server_positive_output_matches' => [qr/PCAP\sfilter.*\s$non_std_spa_port/],
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'random SPA port (tcp/22 ssh)',
        'function' => \&spa_cycle,
        'cmdline'  => "$default_client_args -r",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str " .
            qq|-P "udp"|,
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'spoof username (tcp/22)',
        'function' => \&spa_cycle,
        'cmdline'  => "SPOOF_USER=$spoof_user LD_LIBRARY_PATH=$lib_dir $valgrind_str " .
            "$fwknopCmd -A tcp/22 -a $fake_ip -D $loopback_ip --get-key " .
            "$local_key_file $verbose_str",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'positive_output_matches' => [qr/Username:\s*$spoof_user/],
        'server_positive_output_matches' => [qr/Username:\s*$spoof_user/],
    },

    ### ensure iptables rules are not duplicated for identical (and non-replayed)
    ### access requests
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => "$FW_TYPE rules not duplicated",
        'function' => \&iptables_rules_not_duplicated,
        'cmdline'  => "$default_client_args --test",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
    },

    {
        'category' => 'Rijndael',
        'subcategory' => 'server',
        'detail'   => 'digest cache structure',
        'function' => \&digest_cache_structure,
    },

    ### ipfw only tests
    {
        'category' => 'Rijndael',
        'subcategory' => 'server',
        'detail'   => 'ipfw active/expire sets not equal',
        'function' => \&generic_exec,
        'cmdline' => "$fwknopdCmd -c $cf{'ipfw_active_expire'} -a $cf{'def_access'} " .
            "-d $default_digest_file -p $default_pid_file $intf_str",
        'positive_output_matches' => [qr/Cannot\sset\sidentical\sipfw\sactive\sand\sexpire\ssets/],
        'exec_err' => $YES,
    },
    {
        'category' => 'Rijndael',
        'subcategory' => 'client+server',
        'detail'   => 'localhost hostname->IP spoofed',
        'function' => \&spa_cycle,
        'cmdline' => "$fwknopCmd -A tcp/22 -a $fake_ip -D localhost --get-key " .
            "$local_key_file --no-save-args $verbose_str -P udpraw -Q $spoof_ip",
        'fwknopd_cmdline' => "$fwknopdCmd $default_server_conf_args $intf_str",
        'fw_rule_created' => $NEW_RULE_REQUIRED,
        'fw_rule_removed' => $NEW_RULE_REMOVED,
    },
);
