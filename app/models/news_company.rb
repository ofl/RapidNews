class NewsCompany
  
  include MotionModel::Model
  include MotionModel::ArrayModelAdapter
  include RapidNews::Model

  columns :cc        => :int,
          :name      => :string,
          :locale    => :string,
          :host_name => :string,
          :category  => :string
end