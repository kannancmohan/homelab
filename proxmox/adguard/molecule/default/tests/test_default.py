import testinfra

def test_hosts_file(host):
    f = host.file('/opt/AdGuardHome/AdGuardHome.yaml')
    assert f.exists

def test_service_running(host):
    s = host.service('AdGuardHome')
    assert s.is_running
    assert s.is_enabled
    
def test_web_url_accessible(host):
    output = host.run("curl http://localhost")
    assert output.rc == 0
    assert output.succeeded

def test_port_53_listening(host):
    socket = host.socket("tcp://0.0.0.0:53")
    assert socket.is_listening