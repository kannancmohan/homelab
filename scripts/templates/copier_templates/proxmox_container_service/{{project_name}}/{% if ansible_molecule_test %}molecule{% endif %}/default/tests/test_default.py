import testinfra
    
#def test_web_url_accessible(host):
#    output = host.run("curl http://localhost")
#    assert output.rc == 0
#    assert output.succeeded

#def test_port_80_listening(host):
#    socket = host.socket("tcp://0.0.0.0:80")
#    assert socket.is_listening