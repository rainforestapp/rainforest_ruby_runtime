module Process
  if Gem.win_platform?
    # On Windows:
    # - RLIMIT_NOFILE is not defined
    # - .getrlimit is unimplemented

    RLIMIT_NOFILE = 8

    def self.getrlimit(_resource)
      [256, 1024]
    end
  end
end
