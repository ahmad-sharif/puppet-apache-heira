class apache
(       
        $package_name  = hiera("package_name"),
        $service_name  = hiera("service_name"),
        $conf_dir      = hiera("conf_dir"),
        $log_dir       = hiera("log_dir"),
        $port          = hiera(port),
        $document_root = hiera("document_root"),
        $servername    = hiera(servername),
        $vhost_dir     = hiera("vhost_dir"),
        

){
	
	package {'package_name':
		name    => $package_name,
		ensure  => present


	}


	service {'service_name':
		name    => $service_name,
		ensure  => running,
		enable  => true,
		require => Package['package_name']


	}


	file {'document_root':
		path    => $document_root,
        	ensure  => directory,
        	recurse => true
	}


	file {'log_dir':
		path    => $log_dir,
        	ensure  => directory,
        	recurse => true,
	}

     File {
                mode => 0677,
        }

        file{'index':
                path     => "${document_root}/index.html",
                ensure   => file,
                content  => template('apache/index.html.erb'),
                before   => File['config_file'],
        }

        file {'config_file':
                path      => "${vhost_dir}/${servername}.erb",
                content   => template('apache/vhost.conf.erb'),
                require   => Package['apache'],
                notify    => Service['apache']
        }

}






