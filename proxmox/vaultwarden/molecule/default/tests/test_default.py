import testinfra

def test_service_running(host):
    s = host.service('vaultwarden')
    assert s.is_running
    assert s.is_enabled
    
def test_web_url_accessible(host):
    output = host.run("curl http://localhost:8000")
    assert output.rc == 0
    assert output.succeeded

def test_port_listening(host):
    socket = host.socket("tcp://0.0.0.0:8000")
    assert socket.is_listening