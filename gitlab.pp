exec { 'mkdir-gitlab':
	command		=> 'mkdir /var/tmp/gitlab',
	cwd		=> '/var/tmp',
	provider	=> shell,
	unless		=> 'test -d /var/tmp/gitlab'
}

exec { 'apt-update':
	command		=> '/usr/bin/apt-get update',
	cwd		=> '/var/tmp/gitlab',
	provider	=> shell,
}

package { 'curl':
	name 		=> curl,
	ensure		=> latest,
} 

package { 'openssh-server':
	name		=> openssh-server,
	ensure		=> latest,
}


package { 'ca-certificates':
	name		=> ca-certificates,
	ensure		=> latest
}

package { 'tzdata':
	name		=> tzdata,
	ensure		=> latest,
}

exec { 'add-repository':
	command		=> 'curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash',
	cwd		=> '/var/tmp/gitlab',
	provider	=> shell,
}

package { 'gitlab-ee':
	command		=> gitlab-ee,
	ensure		=> latest,
}


exec { 'external_url': 
	command		=> "sed -i 's+http://gitlab.example.com+https://gitlab.fiaplabs.com+1' gitlab.rb",
	cwd		=> '/etc/gitlab',
	provider	=> shell,
}


exec { 'gitlab_reconfigure': 
	command		=> '/usr/bin/gitlab-ctl reconfigure',
	cwd		=> '/var/tmp/gitlab',
	provider	=> shell,
}


exec { 'gitlab_restart': 
	command		=> '/usr/bin/gitlab-ctl restart',
	cwd		=> '/var/tmp/gitlab',
	provider	=> shell,
}
