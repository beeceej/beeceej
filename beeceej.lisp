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

(defclass nav ()
  ((nav-headers
    :accessor nav-headers
    :initform '(("About" . "/") ("Thoughts" . "/blog")))
   (nav-icons
    :accessor nav-icons
    :initform '(("LinkedIn" . "https://www.linkedin.com/in/beeceej/")
                ("Twitter" . "https://www.twitter.com/_beeceej")
                ("Github" . "https://github.com/beeceej")))))


(defmethod render ((obj nav))
  "render writes the html to a string-stream"
  (with-output-to-string (out-string)
    (xhtmlambda:with-html-syntax-output
        (out-string)
        (flet ((make-link (label ref) (xhtmlambda:a (:class "clickable" :href ref) (string label))))
          (xhtmlambda:nav
           (:class "navigation")
           (xhtmlambda:div
            (:class "flexContainer") (loop :for (label . ref) in (nav-headers obj)
                     collect (make-link label ref )))
           (xhtmlambda:div
            (:class "flexContainer") (loop :for (label . ref) in (nav-icons obj)
                     collect (make-link label ref ))))))))

(defmethod print-object ((obj nav) out)
  (let ((fmt-string ":headers ~a :icons ~a"))
    (print-unreadable-object (obj out :type t)
      (format out fmt-string
              (nav-headers obj)
              (nav-icons obj)))))

(defclass app ()
  ((components :accessor components :initform '() :initarg :components)))


(defun render-components (obj)
  "render-components takes an app object
and renders all of it's components left to right into a string
we do this to ensure each component is rendered correctly"
  (with-output-to-string (out-string)
    (loop
      :for component in (components obj)
      do (format out-string "~a" (render component)))
     out-string ))


(defmethod render ((obj app))
  (with-output-to-string (out-string)
    (xhtmlambda:with-html-syntax-output
        (out-string)
        (xhtmlambda:html
         (xhtmlambda:head
          ()
          (xhtmlambda:meta :charset :utf-8)
          (xhtmlambda:style
           ()
           colorize:*coloring-css*
           ".flexContainer {
              padding: 0;
              margin: 0;
              display: -webkit-box;
              display: -moz-box;
              display: -ms-flexbox;
              display: -webkit-flex;
              display: flex;
              align-items: center;
              justify-content: center;
            }
           .navigation {
              font-family: monospace;
              font-size: 3em;
              color: #357cb2;
            }
            .clickable {
              cursor: pointer;
              color: #357cb2;
              text-decoration: none;
              font-weight: bold;
              margin: 10px;
            }

            .clickable:hover {
              color: #185180;
              font-weight: bold;
            }
            "

           ))
         (xhtmlambda:body
          ()
          (render-components obj)
          )
         ;; Some Javascript goes down here
         (xhtmlambda:script "")))))

(defmethod print-object ((obj app) out)
  (let ((fmt-string "~a"))
    (print-unreadable-object (obj out :type t)
      (format out fmt-string (components obj)))))
