attributes :department, :email, :name, :title
child(:phones) { extends "phones/phone" }
