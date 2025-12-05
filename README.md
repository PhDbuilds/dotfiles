# ansible-dev-setup
Cross-platform development environment setup using Ansible. Supports Ubuntu, Debian, Fedora, and macOS.

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
- **zsh**: Modern shell with oh-my-zsh
- **colorls**: Colorized ls command with icons

## Adding New Tools

This repository is designed to be the single source of truth for your development environment across all devices. When you want to add a new tool, add it to the dotfiles first, then sync to your machines. This helps from getting config drift, if you are like me and care about that.

### Process Overview

1. **Create a new role** for the tool
2. **Add OS-specific installation tasks**
3. **Add configuration files** (if needed)
4. **Include the role** in `main.yml`
5. **Commit and push** to GitHub
6. **Pull and run** the playbook on any machine to sync

### Step-by-Step Example: Adding Lazygit

```bash
# 1. Create the role structure
mkdir -p roles/lazygit/tasks
mkdir -p roles/lazygit/files  # Only if you need config files

# 2. Create the main task file
cat > roles/lazygit/tasks/main.yml << 'EOF'
---
- name: "{{ role_name }} | Run Debian-family tasks"
  ansible.builtin.include_tasks: "Debian.yml"
  when: ansible_os_family == "Debian"

- name: "{{ role_name }} | Run Darwin tasks"
  ansible.builtin.include_tasks: "Darwin.yml"
  when: ansible_os_family == "Darwin"

- name: "{{ role_name }} | Run RedHat-family tasks"
  ansible.builtin.include_tasks: "RedHat.yml"
  when: ansible_os_family == "RedHat"
EOF

# 3. Create OS-specific installation files
cat > roles/lazygit/tasks/Debian.yml << 'EOF'
---
- name: "Lazygit | Debian-family | Add Lazygit PPA (Ubuntu/Debian only)"
  ansible.builtin.apt_repository:
    repo: ppa:lazygit-team/release
    state: present
    update_cache: true
  become: true
  when: ansible_distribution != "Kali"

- name: "Lazygit | Debian-family | Install Lazygit"
  ansible.builtin.apt:
    name: lazygit
    state: present
  become: true
EOF

cat > roles/lazygit/tasks/Darwin.yml << 'EOF'
---
- name: "Lazygit | Darwin | Install Lazygit"
  community.general.homebrew:
    name: lazygit
    state: present
EOF

cat > roles/lazygit/tasks/RedHat.yml << 'EOF'
---
- name: "Lazygit | RedHat-family | Add Lazygit COPR repository"
  ansible.builtin.command:
    cmd: dnf copr enable atim/lazygit -y
  become: true
  changed_when: false

- name: "Lazygit | RedHat-family | Install Lazygit"
  ansible.builtin.dnf:
    name: lazygit
    state: present
  become: true
EOF

# 4. Add the role to main.yml
# Edit main.yml and add under the tasks section:
#     - name: Set up Lazygit
#       ansible.builtin.include_role:
#         name: lazygit

# 5. Test locally first (optional but recommended)
ansible-playbook main.yml --ask-become-pass --tags "lazygit"

# 6. Commit and push your changes
git add roles/lazygit main.yml
git commit -m "Add Lazygit role"
git push origin main
```

### Syncing to Other Machines

Once you've pushed your changes to GitHub, syncing to any other machine is simple:

```bash
cd dotfiles
git pull origin main
ansible-playbook main.yml --ask-become-pass
```

### Adding Configuration Files

If your tool needs configuration files (like tmux or zsh), add them to `roles/<tool>/files/`:

```bash
# Example: Adding a Lazygit config
cat > roles/lazygit/files/config.yml << 'EOF'
# Your lazygit configuration here
EOF

# Then in your main.yml for that role, add a task to copy the config:
# - name: "Lazygit | Configure"
#   ansible.builtin.copy:
#     src: config.yml
#     dest: "{{ ansible_user_dir }}/.config/lazygit/config.yml"
#     mode: "0644"
#     force: true
```

