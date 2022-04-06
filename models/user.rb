class User < ActiveRecord::Base
  has_many :stars, class_name: "Follow", foreign_key: "star_ident", primary_key: "ident"
  has_many :fans, class_name: "Follow", foreign_key: "fan_ident", primary_key: "ident"
end
