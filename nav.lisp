;;;; nav.lisp

(in-package #:beeceej)

(defvar *some-javascript* "console.log(\"common-lisp motha fucka\")")
(defvar *mega-app* (make-instance 'app :components `(,*nav-foo*)))

(defclass nav ()
  ((nav-headers
    :accessor nav-headers
    :initform '(("About" . "/") ("Thoughts" . "/blog")))
   (nav-icons
    :accessor nav-icons
    :initform '(
                ("LinkedIn" . "https://www.linkedin.com/in/beeceej/")
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
and renders all of it's components left to right into a string"
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
          (get-body obj)
          )
         (xhtmlambda:script "")
         ;; ()
         ))))

;; (xhtmlambda:body
;;  ()
;;  (loop
;;    :for component in (components obj)
;;    collect (render (eval component) out-stream))
;;  (xhtmlambda:script
;;   *some-javascript*))

(defmethod print-object ((obj app) out)
  (let ((fmt-string "~a"))
    (print-unreadable-object (obj out :type t)
      (format out fmt-string (components obj)))))


(render *mega-app* *standard-output*)





(with-output-to-string (out-string2)
  (xhtmlambda:with-html-syntax-output
      (out-string2)
      (xhtmlambda:html
       ()
       )))
