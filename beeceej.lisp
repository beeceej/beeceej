;;;; beeceej.lisp

(in-package #:beeceej)

(defvar *index-css* nil)
(defvar *index-javascript* nil)
(defvar *all-posts* nil)

(defun init()
  (flet ((read-file (fname)
           (with-open-file (stream fname)
             (let ((contents (make-string (file-length stream))))
               (read-sequence contents stream)
               contents))))
    (print (type-of (read-file "./static/index.js")))
    (setf *index-javascript* (read-file "./static/index.js"))
    (setf *index-css* (read-file "./static/index.css"))))


(defun run ()
  ;; load in our static assets
  (init)
  ;; run does all the things.
  ;; grabs the data.
  ;; turns the dat into an a list
  ;; calls render on app
  (unless *all-posts* (rest (assoc "posts" (get-all-posts) :test #'string=)))
  (let* ((all-posts *all-posts*)
         (nav (make-instance 'nav))
         (posts
           (loop :for post in all-posts
                 collect
                 (make-blog-post-from-alist
                  (get-post
                   (cdr
                    (assoc "normalizedTitle" post :test #'string=))))))
         (app
           (make-instance 'app :components `(,nav ,@posts))))
    (with-open-file (str "./tmp/shit5.html"
                         :direction :output
                         :if-exists :supersede
                         :if-does-not-exist :create)
      (format str "~a" (render app)))
    (setf *all-posts* all-posts)))
