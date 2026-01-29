;;; init.el --- Emacs configuration -*- lexical-binding: t; -*-

;; ============================================================================
;; 基础设置
;; ============================================================================

;; 设置自定义文件位置
(setq custom-file (expand-file-name "etc/custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; 设置缓存目录
(setq user-cache-directory (expand-file-name "var/cache" user-emacs-directory))
(make-directory user-cache-directory t)

;; 将eln-cache目录添加到加载路径（目录已在early-init.el中设置）
(when (and (boundp 'native-comp-eln-load-path)
           (boundp 'native-comp-eln-cache-dir))
  (add-to-list 'native-comp-eln-load-path native-comp-eln-cache-dir))

;; 设置recentf文件位置到var目录
(setq recentf-save-file (expand-file-name "var/recentf" user-emacs-directory))
(make-directory (file-name-directory recentf-save-file) t)

;; ============================================================================
;; 包管理：straight.el + use-package
;; ============================================================================

(straight-use-package 'use-package)

;; 配置use-package使用straight.el
(setq use-package-always-ensure t
      use-package-verbose nil)

;; ============================================================================
;; 基础编辑器配置
;; ============================================================================

;; 基本设置
(setq-default
 ;; 缩进
 indent-tabs-mode nil
 tab-width 4
 ;; 行号
 display-line-numbers-type 'relative
 ;; 编码
 buffer-file-coding-system 'utf-8-unix
 ;; 自动保存
 auto-save-default t
 auto-save-visited-file-name t
 ;; 备份
 backup-by-copying t
 backup-directory-alist `(("." . ,(expand-file-name "var/backup" user-emacs-directory)))
 ;; 自动保存列表目录
 auto-save-list-file-prefix (expand-file-name "var/auto-save-list/.saves-" user-emacs-directory)
 delete-old-versions t
 kept-new-versions 5
 kept-old-versions 2
 version-control t
 ;; 其他
 fill-column 80
 sentence-end-double-space nil
 require-final-newline t
 confirm-kill-emacs 'yes-or-no-p
 use-short-answers t
 visible-bell t
 ring-bell-function 'ignore)

;; 禁用启动画面（dashboard会替代它）
(setq inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t)

;; 显示时间
(display-time-mode 1)
(setq display-time-24hr-format t)

;; 显示列号
(column-number-mode 1)

;; 高亮当前行
(global-hl-line-mode 1)

;; 显示匹配的括号
(show-paren-mode 1)
(setq show-paren-style 'parenthesis)

;; 默认开启行号显示
(global-display-line-numbers-mode 1)

;; 自动配对
(electric-pair-mode 1)

;; 删除选中区域时直接删除
(delete-selection-mode 1)

;; ============================================================================
;; Dashboard：启动屏幕
;; ============================================================================

(use-package dashboard
  :straight t
  :after evil
  :config
  (setq dashboard-banner-logo-title "Happy Hacking Emacs ❤"
        dashboard-startup-banner 'logo
        dashboard-center-content t
        dashboard-show-shortcuts t
        dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-items '((recents  . 5)
                          (bookmarks . 5)
                          (projects . 5))
        dashboard-set-navigator t
        dashboard-set-footer nil)
  (dashboard-setup-startup-hook))

;; ============================================================================
;; UI配置：主题和Modeline
;; ============================================================================

(use-package doom-themes
  :straight t
  :config
  (load-theme 'doom-one t))

(use-package doom-modeline
  :straight t
  :hook (after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-height 25
        doom-modeline-bar-width 4
        doom-modeline-project-detection 'project
        doom-modeline-buffer-file-name-style 'truncate-upto-project
        doom-modeline-icon t
        doom-modeline-major-mode-icon t
        doom-modeline-minor-modes nil))

;; 字体设置
(set-face-attribute 'default nil
                    :font (font-spec :family "MapleMono NF CN" :size 12))
;; 设置中文字体
(dolist (charset '(kana han symbol cjk-misc bopomofo))
  (set-fontset-font t charset
                    (font-spec :family "MapleMono NF CN")))

;; 窗口设置
(setq frame-title-format '("%b - Emacs")
      icon-title-format frame-title-format)

;; ============================================================================
;; Evil模式配置
;; ============================================================================

(use-package undo-fu
  :straight t)

(use-package evil
  :straight t
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-want-C-i-jump nil
        evil-respect-visual-line-mode t
        evil-undo-system 'undo-fu)
  :config
  (evil-mode 1)
  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal)
  
  ;; 启用平滑滚动
  (setq scroll-step 1
        scroll-conservatively 10000
        scroll-margin 3
        scroll-up-aggressively 0.01
        scroll-down-aggressively 0.01)
  
  ;; 设置 C-d 和 C-u 为逐行滚动
  (define-key evil-normal-state-map (kbd "C-d") (lambda () (interactive) (scroll-up-line)))
  (define-key evil-normal-state-map (kbd "C-u") (lambda () (interactive) (scroll-down-line))))

(use-package evil-collection
  :straight t
  :after evil
  :config
  (evil-collection-init))

;; Leader key设置（SPC）
(use-package general
  :straight t
  :after evil
  :config
  ;; 取消evil模式下SPC的默认绑定
  (general-define-key
   :states '(normal visual motion)
   :keymaps 'override
   "SPC" nil)
  ;; 创建leader key定义器
  (general-create-definer leader-key-def
    :states '(normal visual motion)
    :keymaps 'override
    :prefix "SPC"
    :non-normal-prefix "M-SPC")
  ;; 定义SPC SPC为M-x
  (leader-key-def
    "SPC" '(execute-extended-command :which-key "M-x")
    ;; 文件相关
    "f" '(:ignore t :which-key "file")
    "ff" '(find-file :which-key "find file")
    "fI" `(,(lambda () (interactive) (find-file (expand-file-name "init.el" user-emacs-directory))) :which-key "open init.el")
    "fr" '(consult-recent-file :which-key "recent file")
    "fs" '(save-buffer :which-key "save file")
    "fS" '(save-some-buffers :which-key "save all")
    "fR" '(rename-file :which-key "rename file")
    "fD" '(delete-file :which-key "delete file")
    "fy" '(consult-yank-pop :which-key "yank")
    ;; Buffer相关
    "b" '(:ignore t :which-key "buffer")
    "bb" '(consult-buffer :which-key "switch buffer")
    "bB" '(consult-buffer-other-window :which-key "switch buffer other window")
    "bd" '(kill-current-buffer :which-key "kill buffer")
    "bD" '(kill-buffer :which-key "kill buffer (select)")
    "br" '(revert-buffer :which-key "revert buffer")
    "bR" '(rename-buffer :which-key "rename buffer")
    "bs" '(save-buffer :which-key "save buffer")
    "bS" '(save-some-buffers :which-key "save all buffers")
    ;; Window相关
    "w" '(:ignore t :which-key "window")
    "ww" '(other-window :which-key "other window")
    "wd" '(delete-window :which-key "delete window")
    "wD" '(delete-other-windows :which-key "delete other windows")
    "ws" '(split-window-below :which-key "split window below")
    "wv" '(split-window-right :which-key "split window right")
    "wh" '(windmove-left :which-key "window left")
    "wj" '(windmove-down :which-key "window down")
    "wk" '(windmove-up :which-key "window up")
    "wl" '(windmove-right :which-key "window right")
    "wo" '(delete-other-windows :which-key "only window")
    "wu" '(winner-undo :which-key "undo window")
    "wU" '(winner-redo :which-key "redo window")
    ;; 搜索相关
    "s" '(:ignore t :which-key "search")
    "ss" '(consult-line :which-key "fuzzy search in buffer")
    "sj" '(consult-imenu :which-key "jump to symbol in buffer")
    "sJ" '(consult-imenu-multi :which-key "jump to symbol in project")
    "sr" '(consult-ripgrep :which-key "ripgrep search")
    "sg" '(consult-grep :which-key "grep search")
    "sl" '(consult-line :which-key "line search")
    "sL" '(consult-line-multi :which-key "line search multi buffer")))

(use-package which-key
  :straight t
  :init
  (setq which-key-side-window-location 'bottom
        which-key-sort-order 'which-key-key-order-alpha
        which-key-sort-uppercase-first nil
        which-key-add-column-padding 1
        which-key-max-display-columns nil
        which-key-min-display-lines 6
        which-key-side-window-max-width 0.33
        which-key-idle-delay 0.8
        which-key-allow-imprecise-window-fit nil
        which-key-separator " → ")
  :config
  (which-key-mode))

;; ============================================================================
;; 编辑器增强
;; ============================================================================

;; 更好的搜索
(use-package consult
  :straight t
  :bind
  (("C-s" . consult-line)
   ("C-M-s" . consult-line-multi)
   ("C-x b" . consult-buffer)
   ("C-x 4 b" . consult-buffer-other-window)))

;; 更好的文件查找
(use-package vertico
  :straight t
  :init
  (vertico-mode)
  :config
  ;; 加载vertico-directory扩展（包含在vertico包中）
  (require 'vertico-directory)
  ;; 使用vertico-directory的默认键绑定
  (define-key vertico-map (kbd "RET") #'vertico-directory-enter)
  (define-key vertico-map (kbd "DEL") #'vertico-directory-delete-char)
  (define-key vertico-map (kbd "M-DEL") #'vertico-directory-delete-word)
  (add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy))

;; 窗口配置管理（支持撤销/重做）
(use-package winner
  :straight nil
  :config
  (winner-mode 1))

;; 重启Emacs
(use-package restart-emacs
  :straight t
  :config
  (leader-key-def
    "q" '(:ignore t :which-key "quit")
    "qr" '(restart-emacs :which-key "restart emacs")
    "qq" '(save-buffers-kill-emacs :which-key "quit emacs")))

;; ============================================================================
;; 补全系统：Corfu
;; ============================================================================

(use-package corfu
  :straight t
  :init
  (global-corfu-mode)
  :config
  (setq corfu-auto t
        corfu-auto-delay 0.2
        corfu-auto-prefix 2
        corfu-popupinfo-delay '(0.2 . 0.1)
        corfu-preview-current 'insert
        corfu-preselect-first nil
        corfu-on-exact-match nil
        corfu-scroll-margin 4
        corfu-cycle t)
  (corfu-popupinfo-mode))

(use-package corfu-terminal
  :straight t
  :unless (display-graphic-p)
  :config
  (corfu-terminal-mode))

(use-package cape
  :straight t
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-history)
  :config
  (setq cape-dabbrev-min-length 3
        cape-dabbrev-check-other-buffers t))

;; ============================================================================
;; 项目管理：内置project.el
;; ============================================================================

(use-package project
  :straight nil
  :custom
  (project-vc-extra-root-markers '("go.mod" "go.work" ".p4ignore"))
  :config
  ;; 设置projects文件位置到var目录
  (setq project-list-file (expand-file-name "var/projects" user-emacs-directory))
  (make-directory (file-name-directory project-list-file) t)
  (setq project-switch-commands
        '((project-find-file "Find file")
          (project-find-regexp "Find regexp")
          (project-dired "Dired")
          (project-vc-dir "VC-Dir")
          (project-shell-command "Shell command"))))

;; 最近文件列表
(use-package recentf
  :straight nil
  :config
  (setq recentf-max-saved-items 100
        recentf-max-menu-items 15
        recentf-auto-cleanup 'never
        recentf-exclude '("/tmp/" "/var/tmp/" ".git/" ".cache/" "var/"))
  (recentf-mode 1))

;; 项目键绑定
(leader-key-def
  "p" '(:ignore t :which-key "project")
  "pf" '(project-find-file :which-key "find file")
  "pr" '(project-find-regexp :which-key "find regexp")
  "pd" '(project-dired :which-key "dired")
  "pv" '(project-vc-dir :which-key "vc-dir")
  "ps" '(project-switch-project :which-key "switch project")
  "pp" '(project-switch-project :which-key "switch project")
  "pc" '(project-compile :which-key "compile")
  "pk" '(project-kill-buffers :which-key "kill buffers")
  "pa" '(project-remember-projects-under :which-key "add project"))

;; ============================================================================
;; LSP配置：lsp-bridge
;; ============================================================================

;; lsp-bridge 依赖
(use-package yasnippet
  :straight t
  :config
  ;; 设置snippets目录到FHS结构
  (setq yas-snippet-dirs (list (expand-file-name "etc/snippets" user-emacs-directory)))
  (make-directory (car yas-snippet-dirs) t)
  ;; 如果straight安装的yasnippet-snippets有默认snippets，也包含进来
  (let ((straight-snippets-dirs (file-expand-wildcards
                                 (expand-file-name "var/straight/repos/yasnippet-snippets/yasnippet-snippets-*/snippets" user-emacs-directory))))
    (dolist (dir straight-snippets-dirs)
      (add-to-list 'yas-snippet-dirs dir)))
  (yas-global-mode 1)
  (yas-reload-all))

(use-package lsp-bridge
  :straight (:host github :repo "manateelazycat/lsp-bridge"
            :files ("*.el" "*.py" "acm" "core" "langserver" "multiserver" "resources"))
  :after yasnippet evil
  :config
  ;; 注意：lsp-bridge需要安装Python依赖
  ;; 运行: pip3 install epc orjson sexpdata six setuptools paramiko rapidfuzz watchdog packaging
  (global-lsp-bridge-mode)
  (setq lsp-bridge-enable-mode-line t
        lsp-bridge-enable-signature-help t
        lsp-bridge-enable-hover-diagnostic t
        lsp-bridge-enable-auto-format-code nil)
  
  ;; Vim原生快捷键与LSP结合（在LSP模式下设置）
  (defun setup-lsp-bridge-vim-keys ()
    "Setup vim-style keybindings for lsp-bridge in current buffer"
    (when (and (bound-and-true-p evil-mode)
               (bound-and-true-p lsp-bridge-mode)
               lsp-bridge-mode)
      (evil-define-key 'normal (current-local-map)
        ;; gd: 跳转到定义 (go to definition)
        "gd" #'lsp-bridge-find-def
        ;; gD: 跳转到定义（全局，使用LSP）
        "gD" #'lsp-bridge-find-def
        ;; gi: 跳转到实现 (go to implementation)
        "gi" (lambda ()
               (interactive)
               (if (fboundp 'lsp-bridge-find-impl)
                   (lsp-bridge-find-impl)
                 (call-interactively #'evil-goto-line)))
        ;; gr: 查找引用 (go to references)
        "gr" #'lsp-bridge-find-references
        ;; K: 显示文档 (hover documentation)
        "K" #'lsp-bridge-popup-documentation
        ;; [d: 上一个诊断
        "[d" (lambda ()
               (interactive)
               (if (fboundp 'lsp-bridge-diagnostic-jump-prev)
                   (lsp-bridge-diagnostic-jump-prev)
                 (call-interactively #'previous-error)))
        ;; ]d: 下一个诊断
        "]d" (lambda ()
               (interactive)
               (if (fboundp 'lsp-bridge-diagnostic-jump-next)
                   (lsp-bridge-diagnostic-jump-next)
                 (call-interactively #'next-error))))))
  
  ;; 在lsp-bridge模式启用时设置快捷键
  (add-hook 'lsp-bridge-mode-hook #'setup-lsp-bridge-vim-keys))

;; LSP键绑定
(leader-key-def
  "l" '(:ignore t :which-key "lsp")
  "ld" '(lsp-bridge-find-def :which-key "find definition")
  "lr" '(lsp-bridge-find-references :which-key "find references")
  "lh" '(lsp-bridge-popup-documentation :which-key "hover")
  "ls" '(lsp-bridge-rename :which-key "rename")
  "lf" '(lsp-bridge-format-buffer :which-key "format")
  "la" '(lsp-bridge-code-action :which-key "code action"))


;; ============================================================================
;; Buffer标签栏：tabbar
;; ============================================================================

(use-package tabbar
  :straight t
  :config
  (tabbar-mode 1)
  
  ;; 根据主模式对缓冲区进行分组
  (defun my-tabbar-buffer-groups ()
    "Return the list of group names the current buffer belongs to.
Return a list of at least one group name."
    (list
     (cond
      ;; Check major mode
      ((or (eq major-mode 'emacs-lisp-mode)
           (eq major-mode 'lisp-mode))
       "Emacs Lisp")
      ((eq major-mode 'go-mode)
       "Go")
      ((eq major-mode 'python-mode)
       "Python")
      ((eq major-mode 'json-mode)
       "JSON")
      ((eq major-mode 'yaml-mode)
       "YAML")
      ((eq major-mode 'protobuf-mode)
       "Protobuf")
      ((memq major-mode
             '(c-mode c++-mode))
       "C/C++")
      ((memq major-mode
             '(js-mode js2-mode))
       "JavaScript")
      ((eq major-mode 'org-mode)
       "Org")
      ((memq major-mode
             '(text-mode fundamental-mode))
       "Text")
      ;; Check filename
      ((string-match-p (buffer-name) "*scratch*")
       "Scratch")
      ((string-match-p (buffer-name) "*Messages*")
       "Messages")
      ;; Default
      (t
       "Misc"))))
  
  ;; 自定义标签栏外观
  (set-face-attribute 'tabbar-default nil
                      :background "#282c34"
                      :foreground "#5b6268"
                      :height 0.9)
  
  (set-face-attribute 'tabbar-selected nil
                      :background "#5b6268"
                      :foreground "#bbc2cf"
                      :box '(:line-width 1 :color "#5b6268")
                      :weight 'bold)
  
  (set-face-attribute 'tabbar-unselected nil
                      :background "#3a3f44"
                      :foreground "#5b6268"
                      :box '(:line-width 1 :color "#3a3f44"))
  
  (set-face-attribute 'tabbar-button nil
                      :box '(:line-width 1 :color "#282c34")
                      :inherit 'tabbar-default)
  
  (set-face-attribute 'tabbar-button-highlight nil
                      :inherit 'tabbar-default)
  
  (set-face-attribute 'tabbar-highlight nil
                      :background "#4b5263"
                      :foreground "#bbc2cf"
                      :underline nil)
  
  :custom
  ;; 分组函数
  (tabbar-buffer-groups-function 'my-tabbar-buffer-groups)
  
  ;; 标签栏外观设置
  (tabbar-background-color "#282c34")
  (tabbar-selected-background-color "#5b6268")
  (tabbar-selected-foreground-color "#bbc2cf")
  (tabbar-unselected-background-color "#3a3f44")
  (tabbar-unselected-foreground-color "#5b6268")
  (tabbar-button-background-color "#282c34")
  (tabbar-button-highlight "#666666")
  (tabbar-modified "*Modified*")
  (tabbar-separator '(0.5))
  
  ;; 只显示文件缓冲区，隐藏特殊缓冲区
  (tabbar-buffer-list-function
   (lambda ()
     (delq nil
           (mapcar #'(lambda (b)
                       (cond
                        ;; Always include scratch buffer
                        ((string= (buffer-name b) "*scratch*")
                         (buffer-name b))
                        ;; Include file buffers
                        ((buffer-file-name b)
                         (buffer-name b))
                        ;; Include Dired buffers
                        ((eq (with-current-buffer b major-mode) 'dired-mode)
                         (buffer-name b))
                        ;; Include other special buffers you want to see
                        ((string-match-p "^\\*" (buffer-name b))
                         nil)
                        ;; Everything else
                        (t (buffer-name b))))
                   (buffer-list)))))
  
  :bind
  (:map tabbar-mode-map
        ("C-c t p" . tabbar-previous-tab)
        ("C-c t n" . tabbar-next-tab)
        ("C-c t k" . tabbar-kill-tab)
        ("C-c t b" . tabbar-backward-tab)
        ("C-c t f" . tabbar-forward-tab)))

;; ============================================================================
;; 编程语言支持
;; ============================================================================

;; Go语言支持::
(use-package go-mode
  :straight t
  :mode "\\.go\\'"
  :config
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save)
  (add-hook 'go-mode-hook
            (lambda ()
              (setq tab-width 4)
              (setq indent-tabs-mode nil))))

;; Python支持
(use-package python-mode
  :straight t
  :mode ("\\.py\\'" . python-mode)
  :config
  (setq python-indent-offset 4
        python-indent-guess-indent-offset t
        python-indent-guess-indent-offset-verbose nil))

;; JSON支持
(use-package json-mode
  :straight t
  :mode "\\.json\\'"
  :config
  (setq json-reformat:indent-width 2
        json-reformat:pretty-string? t))

;; YAML支持
(use-package yaml-mode
  :straight t
  :mode ("\\.ya?ml\\'" . yaml-mode)
  :config
  (setq yaml-indent-offset 2))

;; Protobuf支持
(use-package protobuf-mode
  :straight t
  :mode "\\.proto\\'"
  :config
  (setq protobuf-indent-offset 2))

;; 保存自定义变量
(when (file-exists-p custom-file)
  (load custom-file))

;;; init.el ends here
