module RapidNews
  module Model
    module ClassMethods
      def save_to_file
        self.serialize_to_file("#{self.name.underscore}.dat")
      end

      def load_from_file
        NSLog("Loading #{self.name.underscore}...")
        self.deserialize_from_file("#{self.name.underscore}.dat")
        self.seed() if self.count == 0
      end

      def seed
        path = NSBundle.mainBundle.pathForResource(self.name.underscore,
                                                   ofType: "yaml",
                                                   inDirectory: "yaml")
        if path.nil?
          NSLog("yaml/#{self.name.underscore}.yaml not found.")
        else
          error = Pointer.new(:object)
          text = NSString.stringWithContentsOfFile(path,
                                                   encoding: NSUTF8StringEncoding,
                                                   error: error)
          array = YAML.load(text)
          array.each { |params| self.create(params) } if array.kind_of?(Array)
          self.save_to_file
        end
      end
    end

    extend ClassMethods

    def self.included(klass)
      klass.extend ClassMethods
    end
  end
end
