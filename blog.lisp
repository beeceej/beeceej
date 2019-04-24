(in-package #:blog.beeceej.com)

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
  (let ((fmt-string ":title ~a :author ~a :blurb ~a :body ~a :id ~a :md5 ~a :normalized-title ~a :posted-at ~a :updated-at ~a :visible ~a"
))
    (print-unreadable-object (obj out :type t)
      (format out fmt-string
              (title obj)
              (author obj)
              "...";; (blurb obj)
              "...";; (body obj)
              (id obj)
              (md5 obj)
              (normalized-title obj)
              (posted-at obj)
              (updated-at obj)
              (visible obj)))))


(defclass nav ()
  ((items :initarg :items :accessor items)
   (icons :initarg :icons :accessor icons)
   ))

(defmethod print-object ((obj nav) out)
  (let ((fmt-string ":items ~a :icons ~a"))
  (print-unreadable-object (obj out :type t)
    (format out fmt-string 
            (items obj)
            (icons obj)))))
