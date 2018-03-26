require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "forgot_password" do
    let(:user) { User.create(name: "user", email: "user@email.com", password: "user") }
    let(:mail) { UserMailer.forgot_password(user) }

    before do
      user.generate_token
      user.password_reset_sent_at = Time.zone.now
      user.save!
    end

    it "renders the headers" do
      expect(mail.subject).to eq("Reset password instructions")
      expect(mail.to).to eq(["user@email.com"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
