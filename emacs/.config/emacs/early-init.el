;;; early-init.el --- Early initialization for Emacs -*- lexical-binding: t; -*-

;; 禁用package.el，使用straight.el
(setq package-enable-at-startup nil)

;; 优化启动速度：设置垃圾回收阈值
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; 禁用不必要的UI元素
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; 设置straight.el的安装路径到var/straight
(setq straight-base-dir (expand-file-name "var/straight" user-emacs-directory))
(make-directory straight-base-dir t)

;; 设置native compilation缓存目录到var/eln-cache（必须在早期设置）
(setq native-comp-eln-cache-dir (expand-file-name "var/eln-cache" user-emacs-directory))
(make-directory native-comp-eln-cache-dir t)
(setq native-compile-target-directory native-comp-eln-cache-dir)
;; 禁用native-compile的警告
(setq native-comp-async-report-warnings-errors nil)

;; 设置straight.el的安装路径
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el"
                         straight-base-dir))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; 设置straight.el的配置
(setq straight-use-package-by-default t
      straight-vc-git-default-protocol 'https)

;; 在启动完成后恢复垃圾回收设置
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 100 1024 1024)
                  gc-cons-percentage 0.1)))

;;; early-init.el ends here
