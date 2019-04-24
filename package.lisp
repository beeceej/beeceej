;;;; package.lisp

(defpackage #:blog.beeceej.com
  (:use #:cl))


(setf drakma:*header-stream* nil)

(defvar all-posts)
(drakma:http-request "https://static.beeceej.com/posts/all.json")


(defun get-all-posts ()
  (setf yason:*parse-object-as* :alist)
  (let ((stream (drakma:http-request "https://static.beeceej.com/posts/all.json"
                                     :want-stream t)))
    (setf (flexi-streams:flexi-stream-external-format stream) :utf-8)
    (yason:parse stream :object-as :alist)))

(defun get-post (name)
  (setf yason:*parse-object-as* :alist)
  (let ((stream (drakma:http-request
                 (format nil "https://static.beeceej.com/posts/~a.json" name)
                 :want-stream t)))
    (setf (flexi-streams:flexi-stream-external-format stream) :utf-8)
    (yason:parse stream :object-as :alist)))


(defun process-post (post-alist)
  (let ((post (make-blog-post-from-alist post-alist)))
    (print (blurb post))
    (cl-markdown:markdown (body post) :stream *standard-output*)))


(defun run ()
  (let ((all-posts (rest (assoc "posts" (get-all-posts) :test #'string=))))
    (loop for post in all-posts do (process-post post))))

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

;;;;

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

(defvar *some-md* "\\nLately I've been writing python, playing with different lisps (mostly common lisp), and doing alot of work on AWS. So I thought I'd write a quick post on a cool python based lisp I've played around with for about 45 minutes.\\n\\n### [Hylang](http://docs.hylang.org/en/stable/)\\n\\nHere's how I've set my environment up for some quick Hylang development (the official docs are also pretty good. I got up and running in 15 min, or less.)\\n\\n```\\n$ pyenv local 3.72 # this is just the latest I had installed already\\n```\\n```\\n$ pyenv virtualenv tmp-hy\\n```\\n```\\n$ pyenv activate 3.7.2/envs/tmp-hy\\n```\\n```\\n$ pip install git+https://github.com/hylang/hy.git\\n```\\n\\nThose 3 incantations will give you a nice sandboxed installation of Hylang. You can run the interpreter by typing just `hy` or you can give it a file to munch on by saying `hy some-code.hy`.\\n\\n\\nSince I've been using DynamoDB a lot lately I thought I'd try out some boto3. Turns out it's pretty easy.\\n\\nif you're following along make sure you've already `$ pip install git+https://github.com/hylang/hy.git` and also make sure to run:\\n`$ pip install boto3`  \\n\\n```\\n(import boto3)\\n(setv dynamo-resource (boto3.resource \"dynamodb\"))\\n(setv blog-post-table (dynamo-resource.Table \"blog-posts\"))\\n(setv key-expr {\\n  \"id\" \"7\"\\n  \"md5\" \"ef7582d3ccac18418063bd19715614af\" })\\n(print key-expr)\\n(setv item (get  (blog-post-table.get-item :Key key-expr ) \"Item\"))\\n(print item)\\n```\\n\\nif you enter: `hy lispy-boto.hy` it will print out the blog post.\\n\\nEven better, we could define a function like:\\n\\n```\\n(setv dynamo-resource (boto3.resource \"dynamodb\"))\\n\\n(defn lispy-get-item [hash_key_name hash_key_val range_key_name range_key_val table_name]\\n  (setv dynamo-table (dynamo-resource.Table table_name))\\n  (setv key-expr {\\n    hash_key_name hash_key_val\\n    range_key_name range_key_val })\\n  (get (dynamo-table.get-item :Key key-expr) \"Item\"))\\n```\\n\\nand we can import that function into plain 'ol python like:\\n\\n```\\nimport hy\\nlispy_boto = __import__(\"lispy-boto\") # hack because I named the file with a `-`\\n\\nitem = lispy_boto.lispy_get_item(\\n  \"id\",\\n  \"7\",\\n  \"md5\",\\n  \"ef7582d3ccac18418063bd19715614af\",\\n  \"blog-posts\") # You could use kwargs to make this more pythonic\\n\\nprint(item)\\n```\\n\\nThis is just scratching the surface, but I was surprised how easy this was and how little fiddling it took.\\n\\nHylang can be found [on github](https://github.com/hylang/hy) and the [docs](http://docs.hylang.org/en/stable/quickstart.html) aren't half bad. Really cool project")

(3bmd:parse-string-and-print-to-stream *some-md* t)

(with-output-to-string)


(with-open-file (stream "sample.html" :direction :output)
  (let((3bmd-code-blocks:*code-blocks* T)
       (3bmd-tables:*tables* T)
       (3bmd:*smart-quotes* T))
    (3bmd:parse-and-print-to-stream #p"writing-a-go-interpreter-in-go.md" stream)))
