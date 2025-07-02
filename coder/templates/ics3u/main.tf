terraform {
  required_providers {
    coder = {
      source = "coder/coder"
    }
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

locals {
  username = data.coder_workspace_owner.me.name
}

data "coder_provisioner" "me" {
}

provider "docker" {
}

data "coder_workspace" "me" {
}
data "coder_workspace_owner" "me" {}

resource "coder_agent" "main" {
  arch           = data.coder_provisioner.me.arch
  os             = "linux"
  display_apps {
    vscode       = false
    web_terminal = true
    ssh_helper   = false
  }

   startup_script = <<-EOT
    set -e

    # Prepare user home with default files on first start.
    if [ ! -f ~/.init_done ]; then
      cp -rT /etc/skel ~
      touch ~/.init_done
    fi
  EOT

  # These environment variables allow you to make Git commits right away after creating a
  # workspace. Note that they take precedence over configuration defined in ~/.gitconfig!
  # You can remove this block if you'd prefer to configure Git manually or using
  # dotfiles. (see docs/dotfiles.md)
  env = {
    GIT_AUTHOR_NAME     = coalesce(data.coder_workspace_owner.me.full_name, data.coder_workspace_owner.me.name)
    GIT_AUTHOR_EMAIL    = "${data.coder_workspace_owner.me.email}"
    GIT_COMMITTER_NAME  = coalesce(data.coder_workspace_owner.me.full_name, data.coder_workspace_owner.me.name)
    GIT_COMMITTER_EMAIL = "${data.coder_workspace_owner.me.email}"
  }

  # The following metadata blocks are optional. They are used to display
  # information about your workspace in the dashboard. You can remove them
  # if you don't want to display any information.
  # For basic resources, you can use the `coder stat` command.
  # If you need more control, you can write your own script.

  metadata {
    display_name = "Home Disk"
    key          = "3_home_disk"
    script       = "coder stat disk --path $${HOME}"
    interval     = 60
    timeout      = 1
  }

  metadata {
    display_name = "CPU Usage (Host)"
    key          = "4_cpu_usage_host"
    script       = "coder stat cpu --host"
    interval     = 10
    timeout      = 1
  }

  metadata {
    display_name = "Memory Usage (Host)"
    key          = "5_mem_usage_host"
    script       = "coder stat mem --host"
    interval     = 10
    timeout      = 1
  }
}

resource "docker_volume" "home_volume" {
  name = "coder-${data.coder_workspace.me.id}-home"
  # Protect the volume from being deleted due to changes in attributes.
  lifecycle {
    ignore_changes = all
  }
  # Add labels in Docker to keep track of orphan resources.
  labels {
    label = "coder.owner"
    value = data.coder_workspace_owner.me.name
  }
  labels {
    label = "coder.owner_id"
    value = data.coder_workspace_owner.me.id
  }
  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.me.id
  }
  # This field becomes outdated if the workspace is renamed but can
  # be useful for debugging or cleaning out dangling volumes.
  labels {
    label = "coder.workspace_name_at_creation"
    value = data.coder_workspace.me.name
  }
}

resource "docker_image" "main" {
  name = "coder-${data.coder_workspace.me.id}"
  build {
    context = "./"
    build_args = {
      USER = local.username
    }
  }
  triggers = {
    dir_sha1 = sha1(join("", [for f in fileset(path.module, "build/*") : filesha1(f)]))
  }
}

resource "docker_container" "workspace" {
  count = data.coder_workspace.me.start_count
  image = docker_image.main.name
  # Uses lower() to avoid Docker restriction on container names.
  name = "coder-${data.coder_workspace_owner.me.name}-${lower(data.coder_workspace.me.name)}"
  # Hostname makes the shell more user friendly: coder@my-workspace:~$
  hostname = data.coder_workspace.me.name
  # Use the docker gateway if the access URL is 127.0.0.1
  entrypoint = ["sh", "-c", replace(coder_agent.main.init_script, "/localhost|127\\.0\\.0\\.1/", "host.docker.internal")]
  env        = ["CODER_AGENT_TOKEN=${coder_agent.main.token}"]
  host {
    host = "host.docker.internal"
    ip   = "host-gateway"
  }
  volumes {
    container_path = "/home/${local.username}"
    volume_name    = docker_volume.home_volume.name
    read_only      = false
  }

  # Add labels in Docker to keep track of orphan resources.
  labels {
    label = "coder.owner"
    value = data.coder_workspace_owner.me.name
  }
  labels {
    label = "coder.owner_id"
    value = data.coder_workspace_owner.me.id
  }
  labels {
    label = "coder.workspace_id"
    value = data.coder_workspace.me.id
  }
  labels {
    label = "coder.workspace_name"
    value = data.coder_workspace.me.name
  }
}

module "code-server" {
  source     = "registry.coder.com/modules/code-server/coder"
  version    = "1.0.18"
  agent_id   = coder_agent.main.id
  display_name = "VS Code Web"
  extensions = ["oderwat.indent-rainbow",
                "ms-python.python",
                "medo64.render-crlf"
  ]
  settings = {
              "breadcrumbs.enabled": false,
              "editor.autoClosingBrackets": "always",
              "editor.autoClosingComments": "always",
              "editor.autoIndent": "full",
              "editor.autoSurround": "languageDefined",
              "editor.bracketPairColorization.enabled": true,
              "editor.bracketPairColorization.independentColorPoolPerBracketType": true,
              "editor.autoClosingQuotes": "languageDefined",
              "editor.autoClosingOvertype": "auto",
              "editor.comments.insertSpace": true,
              "editor.dragAndDrop": true,
              "editor.detectIndentation": true,
              "editor.folding": false,
              "editor.formatOnPaste": true,
              "editor.guides.bracketPairs": "active",
              "editor.guides.indentation": true,
              "editor.inlineSuggest.enabled": true,
              "editor.insertSpaces": true,
              "editor.lightbulb.enabled": false,
              "editor.lineNumbers": "on",
              "editor.minimap.enabled": false,
              "editor.mouseWheelZoom": true,
              "editor.renderWhitespace": "all",
              "editor.showFoldingControls": "never",
              "editor.smoothScrolling": true,
              "editor.stickyScroll.enabled": false,
              "editor.tabCompletion": "on",
              "editor.tabSize": 4
              "editor.wordWrap": "off",
              "explorer.confirmDragAndDrop": false,
              "extensions.ignoreRecommendations": true,
              "files.autoSave": "afterDelay",
              "files.eol": "\n",
              "git.autofetch": true,
              "git.confirmSync": false,
              "git.enableSmartCommit": true,
              "git.closeDiffOnOperation": true,
              "git.ignoreRebaseWarning": true,
              "terminal.integrated.copyOnSelection": true,
              "terminal.integrated.mouseWheelZoom": true,
              "terminal.integrated.rightClickBehavior": "copyPaste",
              "window.menuBarVisibility": "classic",
              "workbench.colorTheme": "Visual Studio Dark",
              "workbench.startupEditor": "none",
              "workbench.tips.enabled": false,
  }
}
