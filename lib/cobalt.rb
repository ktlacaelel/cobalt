require 'rubygems'
require 'isna'
require 'logger'

module Cobalt

  class Console

    attr_accessor :separator_length

    def initialize( options = {} )
      @indent           = 0
      @loggers          = options[:loggers] || [::Logger.new(STDOUT)]
      @separator_length = 120
      @color            = :white
    end

    def add_logger logger
      @loggers << logger
    end

    def remove_logger logger
      @loggers = @loggers - [logger]
    end

    def log(*objects)
      objects.each do |object|
        the_string = object.to_s
        the_string = the_string.to_ansi.send(@color).to_s
        the_string = the_string.gsub(/^/, ' ' * @indent)
        @loggers.each { |logger| logger.info(the_string) }
      end
      self
    end

    def pp(*objects)
      dump = ""
      if objects.size > 1
        PP.pp(objects, dump)
      else
        PP.pp(objects.first, dump)
      end
      log(dump)
    end

    def info(*objects)
      notice(*objects)
    end

    def notice(*objects)
      color(:cyan) { log(*objects) }
    end

    def warn(*objects)
      color(:yellow) { log(*objects) }
    end

    def error(*objects)
      color(:red) { log(*objects) }
    end

    def separator(type = '-')
      log((type * (@separator_length - @indent)))
    end

    def space(lines = 1)
      lines.times { self.log('') }
      self
    end

    def indent
      if block_given?
        @indent = @indent + 2
        yield
        @indent = @indent - 2
      else
        @indent = @indent + 2
      end
      self
    end

    def outdent
      @indent = @indent - 2
      self
    end

    def color(symbol)
      if block_given?
        old = @color
        @color = symbol
        yield
        @color = old
      else
        @color = symbol
      end
      self
    end

  end

end
