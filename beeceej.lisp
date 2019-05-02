;;;; blog.beeceej.com.lisp

(in-package #:beeceej)

(defclass blog-post ()
  ((title :initarg :title :accessor title)
   (author :initarg :author :accessor author)
   (blurb :initarg :blurb :accessor blurb)
   (body :initarg :body :accessor body)
   (id :initarg :id :accessor id)
   (md5 :initarg :md5 :accessor md5)
   (normalized-title :initarg :normalized-title :accessor normalized-title)
   (posted-at :initarg :posted-at :accessor posted-at)
   (updated-at :initarg :updated-at :accessor updated-at)
   (visible :initarg :visible :accessor visible)))


(defmethod render ((obj blog-post))
  "render writes the html to the out-stream passed in"
  (with-output-to-string (out-string)
    (xhtmlambda:with-html-syntax-output
        (out-string)
        (xhtmlambda:div
         ()
         (xhtmlambda:div
          ()
          ;; Render The Markdown
          (let ((3bmd-code-blocks:*code-blocks* T)
                (3bmd-tables:*tables* T)
                (3bmd:*smart-quotes* T))
            (with-output-to-string (out-string)
              (3bmd:parse-string-and-print-to-stream (body obj) out-string))))))))

(defun process-post (post-alist)
  (let ((post (make-blog-post-from-alist post-alist))
        (3bmd-code-blocks:*code-blocks* T)
        (3bmd-tables:*tables* T)
        (3bmd:*smart-quotes* T))
    (3bmd:parse-string-and-print-to-stream (body post) t)))


(defun run ()
  (let* ((all-posts (rest (assoc "posts" (get-all-posts) :test #'string=)))
         (nav (make-instance 'nav))
         (posts (loop :for post in all-posts collect
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
      (format str "~a" (render app)))))


(defun make-blog-post-from-alist (raw-post)
  (flet ((get-val (key) (cdr (assoc key raw-post :test #'string=))))
    (make-instance 'blog-post
                   :title (get-val "title")
                   :author (get-val "author")
                   :blurb (get-val "blurb")
                   :body (get-val "body")
                   :id (get-val "id")
                   :md5 (get-val "md5")
                   :normalized-title (get-val "normalizedTitle")
                   :posted-at (get-val "postedAt")
                   :updated-at (get-val "updatedAt")
                   :visible (get-val "visible")
                   )))


(defmethod print-object ((obj blog-post) out)
  (print-unreadable-object (obj out :type t)
    (format out
            ":title ~a :author ~a :blurb ~a :body ~a :id ~a :md5 ~a :normalized-title ~a :posted-at ~a :updated-at ~a :visible ~a"
                               (title obj)
                               (author obj)
                               "...";; (blurb obj)
                               "...";; (body obj)
                               (id obj)
                               (md5 obj)
                               (normalized-title obj)
                               (posted-at obj)
                               (updated-at obj)
                               (visible obj))))
