# Install Nginx if not already installed
package { 'nginx':
  ensure => installed,
}

# Create necessary directories
file { '/data/':
  ensure  => directory,
  owner   => 'ubuntu',
  group   => 'ubuntu',
  recurse => true,
}

file { '/data/web_static/':
  ensure  => directory,
  owner   => 'ubuntu',
  group   => 'ubuntu',
}

file { '/data/web_static/releases/':
  ensure  => directory,
  owner   => 'ubuntu',
  group   => 'ubuntu',
}

file { '/data/web_static/shared/':
  ensure  => directory,
  owner   => 'ubuntu',
  group   => 'ubuntu',
}

file { '/data/web_static/releases/test/':
  ensure  => directory,
  owner   => 'ubuntu',
  group   => 'ubuntu',
}

# Create a fake HTML file
file { '/data/web_static/releases/test/index.html':
  ensure  => file,
  owner   => 'ubuntu',
  group   => 'ubuntu',
  content => '<html><body>This is a test HTML file.</body></html>',
}

# Create a symbolic link
file { '/data/web_static/current':
  ensure => link,
  target => '/data/web_static/releases/test/',
  force  => true,
}

# Update Nginx configuration
file { '/etc/nginx/sites-available/default':
  ensure => present,
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
  content => "# Nginx configuration
server {
    listen 80;
    listen [::]:80;

    server_name didnow.tech;

    location /hbnb_static {
        alias /data/web_static/current/;
        index index.html;
    }

    location / {
        # Other configurations for your site
    }
}",
  require => Package['nginx'],
}

# Restart Nginx after updating configuration
service { 'nginx':
  ensure  => running,
  enable  => true,
  require => File['/etc/nginx/sites-available/default'],
}
