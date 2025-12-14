# qutebrowser config
# Vim-native, keyboard-driven browser configuration
# Works on macOS and Linux

# Load autoconfig (for :set commands saved via UI)
config.load_autoconfig(False)

# ============================================
# APPEARANCE
# ============================================

# Dark mode
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.preferred_color_scheme = 'dark'

# Font
c.fonts.default_family = 'JetBrainsMono Nerd Font'
c.fonts.default_size = '12pt'

# Minimal UI
c.statusbar.show = 'in-mode'  # Only show in command mode
c.tabs.show = 'multiple'       # Only show tabs when >1 tab

# ============================================
# BEHAVIOR
# ============================================

# Start page
c.url.start_pages = ['about:blank']
c.url.default_page = 'about:blank'

# Search engines
c.url.searchengines = {
    'DEFAULT': 'https://duckduckgo.com/?q={}',
    'g': 'https://www.google.com/search?q={}',
    'gh': 'https://github.com/search?q={}',
    'yt': 'https://www.youtube.com/results?search_query={}',
    'wiki': 'https://en.wikipedia.org/wiki/{}',
    'rs': 'https://doc.rust-lang.org/std/?search={}',
    'mdn': 'https://developer.mozilla.org/en-US/search?q={}',
}

# Downloads
c.downloads.location.directory = '~/Downloads'
c.downloads.location.prompt = False

# Smooth scrolling
c.scrolling.smooth = True

# ============================================
# PRIVACY (Google-free)
# ============================================

c.content.cookies.accept = 'no-3rdparty'
c.content.geolocation = False
c.content.headers.do_not_track = True

# Block ads (basic)
c.content.blocking.enabled = True
c.content.blocking.method = 'both'
c.content.blocking.adblock.lists = [
    'https://easylist.to/easylist/easylist.txt',
    'https://easylist.to/easylist/easyprivacy.txt',
]

# ============================================
# KEYBINDINGS (Vim-native)
# ============================================

# Leader key bindings (Space as leader)
config.bind('<Space>b', 'set-cmd-text -s :buffer')
config.bind('<Space>t', 'set-cmd-text -s :open -t')
config.bind('<Space>o', 'set-cmd-text -s :open')
config.bind('<Space>h', 'home')
config.bind('<Space>H', 'back')
config.bind('<Space>L', 'forward')
config.bind('<Space>r', 'reload')
config.bind('<Space>R', 'reload -f')

# Tab navigation (like vim buffers)
config.bind('J', 'tab-prev')
config.bind('K', 'tab-next')
config.bind('gT', 'tab-prev')
config.bind('gt', 'tab-next')
config.bind('g0', 'tab-focus 1')
config.bind('g$', 'tab-focus -1')

# Quick marks
config.bind('m', 'set-cmd-text -s :quickmark-save')
config.bind("'", 'set-cmd-text -s :quickmark-load')
config.bind('"', 'set-cmd-text -s :quickmark-load -t')

# Scroll (vim-like)
config.bind('j', 'scroll-px 0 50')
config.bind('k', 'scroll-px 0 -50')
config.bind('h', 'scroll-px -50 0')
config.bind('l', 'scroll-px 50 0')
config.bind('<Ctrl-d>', 'scroll-page 0 0.5')
config.bind('<Ctrl-u>', 'scroll-page 0 -0.5')
config.bind('<Ctrl-f>', 'scroll-page 0 1')
config.bind('<Ctrl-b>', 'scroll-page 0 -1')

# Hints (like Vimium)
config.bind('f', 'hint')
config.bind('F', 'hint all tab')
config.bind(';i', 'hint images')
config.bind(';I', 'hint images tab')
config.bind(';y', 'hint links yank')

# Clipboard
config.bind('yy', 'yank')
config.bind('yt', 'yank title')
config.bind('p', 'open -- {clipboard}')
config.bind('P', 'open -t -- {clipboard}')

# Close/undo
config.bind('d', 'tab-close')
config.bind('u', 'undo')
config.bind('x', 'tab-close')

# Command mode
config.bind(':', 'set-cmd-text :')
config.bind('/', 'set-cmd-text /')
config.bind('?', 'set-cmd-text ?')
config.bind('n', 'search-next')
config.bind('N', 'search-prev')

# Insert mode escape
config.bind('<Escape>', 'mode-leave', mode='insert')
config.bind('<Ctrl-[>', 'mode-leave', mode='insert')
config.bind('jk', 'mode-leave', mode='insert')

# ============================================
# PASS-THROUGH SITES
# ============================================

# Sites where you want all keys passed through (e.g., web apps)
# config.bind('<Ctrl-v>', 'mode-enter passthrough')
# config.bind('<Escape>', 'mode-leave', mode='passthrough')
