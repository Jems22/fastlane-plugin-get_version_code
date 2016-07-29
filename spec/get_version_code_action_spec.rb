describe Fastlane::Actions::GetVersionCodeAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The get_version_code plugin is working!")

      Fastlane::Actions::GetVersionCodeAction.run(nil)
    end
  end
end
