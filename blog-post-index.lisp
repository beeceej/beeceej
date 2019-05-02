
(in-package #beeceej)

(defclass blog-post-index ()
  ((posts :initarg :posts :accessor posts)))

(defun get-post-index ()
  (let ((all-posts (rest (assoc "posts" (get-all-posts) :test #'string=))))
    (make-instance 'blog-post-index :posts all-posts)
    ))

(defmethod print-object ((obj blog-post-index) out)
  (print-unreadable-object (obj out :type t)
    (format out ":items ~a :icons ~a"
            (posts obj))))

;; (defun run ()
;;   (let ((all-posts (rest (assoc "posts" (get-all-posts) :test #'string=))))
;;     (loop for post in all-posts do (process-post post))))


;; (loop for post in all-posts do (process-post post))
