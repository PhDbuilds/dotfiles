# ansible-dev-setup
Cross-platform development environment setup using Ansible. Supports Ubuntu, Debian, Kali Linux, Fedora, and macOS.

[TechDufus](https://github.com/TechDufus/dotfiles) was a huge inspiration for this project 
## Installation

### Prerequisites

**Ubuntu/Debian/Kali:**
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install essential tools
sudo apt install -y git curl software-properties-common

# Install Ansible
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

# Install required Ansible collections
ansible-galaxy collection install community.general
```

**Fedora:**
```bash
# Update system
sudo dnf update -y

# Install essential tools
sudo dnf install -y git curl dnf-plugins-core

# Install Ansible
sudo dnf install -y ansible

# Install required Ansible collections
ansible-galaxy collection install community.general
```

**macOS:**
```bash
# Install via Homebrew if you already have it
brew install ansible

# Install required Ansible collections
ansible-galaxy collection install community.general
```

### Quick Setup

1. Clone the repository
```bash
git clone https://github.com/PhDbuilds/dotfiles.git
cd dotfiles
```

2. Run the full playbook
```bash
ansible-playbook main.yml --ask-become-pass
```

3. Or run specific roles only
```bash
# Install only Neovim and tmux
ansible-playbook main.yml --ask-become-pass --limit localhost --tags "neovim,tmux"
```

## What's Included

### Core Tools

- **Neovim**: Modern Vim-based editor with comprehensive Lua configuration
- **tmux**: Terminal multiplexer with custom configuration
- **zsh**: Modern shell
