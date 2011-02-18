# encoding: utf-8
# (c) 2011 Martin Kozák (martinkozak@martinkozak.net)

require "command-builder"
require "pipe-run"
require "hash-utils/hash"

##
# UNIX +whereis+ command frontend.
# @see
#

class Whereis

    ##
    # Target types to arguments conversion table.
    #

    TYPES = {
        :binary => :b,
        :manual => :m,
        :source => :s,
        :unusual => :u,
    }
    
    ##
    # Target type path settings to arguments conversion table.
    #
    
    PATHS = {
        :binary => :B,
        :manual => :M,
        :source => :S,
    }
    
    ##
    # Checks where is some file. By default uses default 
    # whereis options.
    #
    # @overload file?(name, options = nil)
    #   Checks according to file name and single type specification. 
    #   Can be replaced by specialized methods of the module which use 
    #   it. Type specification can be +:binary+, +:manual+ or +:source+.
    #   @param [String] name name or wildcard of the file
    #   @param [Symbol] options type of the file
    #   @return [Array] list of found locations
    #
    # @overload file?(name, options = [ ])
    #   Allows define multiple types for checking with eventual addition 
    #   of the +whereis+ "unusual" setting.
    #   @param [String] name name or wildcard of the file
    #   @param [Array] options array of type of the files and eventually the +:unusual+ specification
    #   @return [Array] list of found locations
    #   @see TYPES
    #   
    # @overload file?(name, options = { })
    #   Allows define paths for each type and eventually the unusual 
    #   settings too.
    #   @param [String] name name or wildcard of the file
    #   @param [Hash] options path specifications and/or +:unusual+ setting (see below)
    #   @option options [String] :binary path to binaries folder
    #   @option options [String] :manual path to manual pages folder
    #   @option options [String] :source path to sources folder
    #   @option options [Boolean] :unusual +true+ for set the "unusual" flag
    #   @return [Array] list of found locations
    #   @see PATHS
    #
    # @return [Array] list of found locations
    #

    def self.file?(name, options = [ ])
    
        # Parses arguments
        cmd = CommandBuilder::new(:whereis)
 
        if options.kind_of? Symbol
            __add_type(cmd, options)
        elsif options.kind_of? Array
            options.each { |i| __add_type(cmd, i) }
        elsif options.kind_of? Hash
            options.each_pair { |n, v| __add_path(cmd, n, v) }
        end
        
        cmd << name.to_s
        
        # Parses output
        output = Pipe.run(cmd.to_s)[(name.to_s.length + 2)..-1]
        return output.split(" ")
    end
    
    ##
    # Checks where is some binary file. By default uses default 
    # whereis options.
    #
    # @overload binary?(name, options = nil)
    #   Checks according to name and +:unusual+ settings.
    #   @param [String] name name or wildcard of the file
    #   @param [:unusual, nil] options  eventuall +:unusual+ settings
    #   @return [Array] list of found locations
    # @overload binary?(name, options = { })
    #   Checks according to name and additionaů options.
    #   @param [String] name name or wildcard of the file
    #   @param [Hash] options options
    #   @option options [String] :path path to binary folder
    #   @option options [Boolean] :unusual +true+ it it's set, +false+ in otherwise
    #   @return [Array] list of found locations
    #
    # @return [Array] list of found locations
    #
    
    def self.binary?(name, options = nil)
        __get(name, :binary, options)
    end
    
    ##
    # Checks where is some manual page file. By default uses default 
    # whereis options.
    #
    # @overload manual?(name, options = nil)
    #   Checks according to name and +:unusual+ settings.
    #   @param [String] name name or wildcard of the file
    #   @param [:unusual, nil] options  eventuall +:unusual+ settings
    #   @return [Array] list of found locations
    # @overload manual?(name, options = { })
    #   Checks according to name and additionaů options.
    #   @param [String] name name or wildcard of the file
    #   @param [Hash] options options
    #   @option options [String] :path path to manual pages folder
    #   @option options [Boolean] :unusual +true+ it it's set, +false+ in otherwise
    #   @return [Array] list of found locations
    #
    # @return [Array] list of found locations
    #
    
    def self.manual?(name, options = nil)
        __get(name, :manual, options)
    end
    
    ##
    # Checks where is some source file. By default uses default 
    # whereis options.
    #
    # @overload source?(name, options = nil)
    #   Checks according to name and +:unusual+ settings.
    #   @param [String] name name or wildcard of the file
    #   @param [:unusual, nil] options  eventuall +:unusual+ settings
    #   @return [Array] list of found locations
    # @overload source?(name, options = { })
    #   Checks according to name and additionaů options.
    #   @param [String] name name or wildcard of the file
    #   @param [Hash] options options
    #   @option options [String] :path path to source folder
    #   @option options [Boolean] :unusual +true+ it it's set, +false+ in otherwise
    #   @return [Array] list of found locations
    #
    # @return [Array] list of found locations
    #
    
    def self.source?(name, options = nil)
        __get(name, :source, options)
    end
    
    ##
    # Indicates, file of the target type is available.
    #
    
    def self.available?(name, type = :binary)
        self.file?(name, type).length > 0
    end
    

    
    private
    
    ##
    # Translates type specific calls to general calls.
    #
    
    def self.__get(name, type, options = nil)
        if options.kind_of? Hash
            arg = { }
            if options[:path]
                arg[type] = options[:path]
            end
            if options[:unusual]
                arg[:unusual] = options[:unusual]
            end
        elsif options == :unusual
            arg = [type, :unusual]
        elsif options.kind_of? NilClass
            arg = type
        else 
            raise Exception::new("Hash, Symbol or nil expected in options.")
        end
        
        self.file?(name, arg)
    end
    
    ##
    # Adds type argument to command according to type specification.
    #
    
    def self.__add_type(cmd, type)
        cmd << self::TYPES[type]
    end

    ##
    # Adds path arguments to command according to type and 
    # paths specification.
    #
        
    def self.__add_path(cmd, type, path)
        if type != :unusual
            cmd.arg(self::PATHS[type], path)
        end
        
        __add_type(cmd, type)
    end
    
end
