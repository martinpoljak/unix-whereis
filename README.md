Unix Whereis
============

**Unix Whereis** provides Ruby interface to UNIX whereis command. 
Some examples follows: (for details, see module documentation)

    require "unix/whereis"
    
    Whereis.file? :ls   
    # will return ["/bin/ls", "/usr/share/man/man1/ls.1.gz", "/usr/share/man/man1/ls.1p.gz"]
    
    Whereis.binary? :ls
    # will return ["/bin/ls"]
    
    Whereis.available? :ls
    # will return true
    
Contributing
------------

1. Fork it.
2. Create a branch (`git checkout -b 20101220-my-change`).
3. Commit your changes (`git commit -am "Added something"`).
4. Push to the branch (`git push origin 20101220-my-change`).
5. Create an [Issue][2] with a link to your branch.
6. Enjoy a refreshing Diet Coke and wait.

Copyright
---------

Copyright &copy; 2011 [Martin Kozák][3]. See `LICENSE.txt` for
further details.

[2]: http://github.com/martinkozak/qrpc/issues
[3]: http://www.martinkozak.net/
