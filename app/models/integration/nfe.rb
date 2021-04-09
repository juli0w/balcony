class Nfe
    require 'nokogiri'

    attr_accessor :nfe

    def self.import! nfe
        @nfe = nfe
        test
    end

    def self.test
        raise Exception, @nfe
    end
end