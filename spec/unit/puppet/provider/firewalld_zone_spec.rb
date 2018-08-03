require 'spec_helper'

provider_class = Puppet::Type.type(:firewalld_zone).provider(:firewall_cmd)

describe provider_class do
  let(:resource) do
    @resource = Puppet::Type.type(:firewalld_zone).new(
      ensure: :present,
      name: 'internal',
      description: 'Interface for management',
      interfaces: ["eth0"],
      provider: described_class.name
    )
  end
  let(:provider) { resource.provider }

  before :each do
    provider.class.stubs(:execute_firewall_cmd).returns(Object.any_instance.stubs(:exitstatus => 0))
    provider.class.stubs(:execute_firewall_cmd).with(['--list-interfaces']).returns(Object.any_instance.stubs(:exitstatus => 0, :chomp => ""))
  end

  describe 'when creating' do
    context 'with name white' do
      it "should execute firewall_cmd with new-zone" do
        resource.expects(:[]).with(:name).returns('white').at_least_once
        resource.expects(:[]).with(:target).returns(nil).at_least_once
        resource.expects(:[]).with(:sources).returns(nil).at_least_once
        resource.expects(:[]).with(:interfaces).returns(["eth0"]).at_least_once
        resource.expects(:[]).with(:icmp_blocks).returns(nil).at_least_once
        resource.expects(:[]).with(:description).returns(nil).at_least_once
        resource.expects(:[]).with(:short).returns("little description").at_least_once
        provider.expects(:execute_firewall_cmd).with(["--list-interfaces"])
        provider.expects(:execute_firewall_cmd).with(["--add-interface", 'eth0'])
        provider.expects(:execute_firewall_cmd).with(["--new-zone", 'white'], nil)
        provider.expects(:execute_firewall_cmd).with(["--set-short", 'little description'], "white", true, false)
        provider.create
      end
    end
  end

  describe "when modifying" do
    context "type" do
      it "should remove and create a new ipset" do
        resource.expects(:[]).with(:name).returns('white').at_least_once
        resource.expects(:[]).with(:target).returns(nil).at_least_once
        resource.expects(:[]).with(:sources).returns(nil).at_least_once
        resource.expects(:[]).with(:interfaces).returns(["eth0"]).at_least_once
        resource.expects(:[]).with(:icmp_blocks).returns(nil).at_least_once
        resource.expects(:[]).with(:description).returns(nil).at_least_once
        resource.expects(:[]).with(:short).returns("little description").at_least_once
        provider.expects(:execute_firewall_cmd).with(["--list-interfaces"])
        provider.expects(:execute_firewall_cmd).with(["--add-interface", 'eth0'])
        provider.expects(:execute_firewall_cmd).with(["--new-zone", 'white'], nil)
        provider.expects(:execute_firewall_cmd).with(["--set-short", 'little description'], "white", true, false)
        provider.expects(:execute_firewall_cmd).with(["--set-description", :"Better description"], "white", true, false)
        provider.create

        provider.description = :'Better description'
      end
    end
  end
end
