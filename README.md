# InfraFusion Multi-Tier DevOps Environment

This project automates the full VProfile application stack using Vagrant and service-specific provisioning scripts. It creates a multi-tier environment where each component runs in its own VM and communicates over the internal network.

## Project Goal

Set up a working Linux-based infrastructure for the VProfile application with the following services in the required order:

1. MySQL (Database SVC)
2. Memcache (DB Caching SVC)
3. RabbitMQ (Broker / Queue SVC)
4. Tomcat (Application SVC)
5. Nginx (Web SVC)

The stack is designed based on the setup instructions in the project PDF: `VprofileProjectSetupWindowsAndMacIntel.pdf`.

## Architecture

The environment contains five VMs:

- `db01` — MariaDB database
- `mc01` — Memcached cache layer
- `rmq01` — RabbitMQ message broker
- `app01` — Tomcat application server
- `web01` — Nginx frontend proxy

## Prerequisites

Install these tools on the host machine before running the environment:

- Oracle VM VirtualBox
- Vagrant
- Git Bash or any equivalent shell environment
- Vagrant plugin: `vagrant-hostmanager`

Install the plugin:

```bash
vagrant plugin install vagrant-hostmanager
```

## Repository Structure

```text
InfraFusion Multi-Tier DevOps Environment/
├── Vagrantfile
├── README.md
├── scripts/
│   ├── db01-setup.sh
│   ├── mc01-setup.sh
│   ├── rmq01-setup.sh
│   ├── app01-setup.sh
│   └── web01-setup.sh
```

## VM Details

| VM Name | Hostname | IP | OS | Purpose |
|--------|----------|----|----|---------|
| db01 | db01 | 192.168.56.11 | CentOS 8 | MariaDB database |
| mc01 | mc01 | 192.168.56.12 | CentOS 8 | Memcached cache |
| rmq01 | rmq01 | 192.168.56.13 | CentOS 8 | RabbitMQ messaging |
| app01 | app01 | 192.168.56.14 | CentOS 8 | Tomcat app server |
| web01 | web01 | 192.168.56.15 | Ubuntu 22.04 | Nginx web frontend |

## Setup Workflow

Follow the same sequence described in the project PDF:

```bash
# 1. Clone source code
# 2. Move into the repository
# 3. Switch to main branch
# 4. Go to the vagrant directory
vagrant up
```

> If provisioning stops in the middle, run the same command again: `vagrant up`

The Vagrant hostmanager plugin automatically updates host entries and `/etc/hosts` entries for the VMs.

## Service Provisioning Order

The project provisions services in this order:

1. `db01` — MySQL / MariaDB
2. `mc01` — Memcache
3. `rmq01` — RabbitMQ
4. `app01` — Tomcat
5. `web01` — Nginx

## How to Start the Environment

From the project root directory:

```bash
vagrant up
```

This command creates the VMs and runs the corresponding service scripts for each one.

## How to Connect to VMs

```bash
vagrant ssh db01
vagrant ssh mc01
vagrant ssh rmq01
vagrant ssh app01
vagrant ssh web01
```

## Application Access

After the provisioning completes successfully, the application should be available through the Nginx VM:

```text
http://web01/
```

## Useful Commands

Check VM status:

```bash
vagrant status
```

Re-run provisioning:

```bash
vagrant provision
```

Stop machines:

```bash
vagrant halt
```

Destroy machines:

```bash
vagrant destroy -f
```

## Service Notes

### DB VM (`db01`)
- Installs `mariadb-server`
- Secures the database with a root password
- Creates the `accounts` database
- Grants privileges to the `admin` user
- Imports the application database backup

### Memcache VM (`mc01`)
- Installs `memcached`
- Starts it on port `11211`
- Opens firewall access

### RabbitMQ VM (`rmq01`)
- Installs RabbitMQ server
- Creates the `test` user and sets admin tags
- Opens port `5672`

### Tomcat VM (`app01`)
- Installs Java 11 and Maven
- Downloads Tomcat 9
- Creates the Tomcat service
- Clones the VProfile repo
- Builds the application
- Deploys the WAR file to Tomcat

### Nginx VM (`web01`)
- Installs Nginx
- Creates the app proxy configuration
- Removes default site config
- Enables the VProfile route

## Troubleshooting

### Missing Vagrant plugin

```bash
vagrant plugin install vagrant-hostmanager
```

### Provisioning failed midway

```bash
vagrant up
```

### Check environment health

```bash
vagrant status
vagrant ssh db01
systemctl status mariadb
```

## References

- Project PDF: `VprofileProjectSetupWindowsAndMacIntel.pdf`
- Application source: `https://github.com/hkhcoder/vprofile-project`

## License

This project is intended for learning, DevOps practice, and infrastructure automation exercises.
