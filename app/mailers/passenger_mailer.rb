class PassengerMailer < ApplicationMailer
    default from: 'notification@messagingcenter.com'

    def email
        @passenger = params[:passenger]
        mail(to: @passenger.email, subject: 'About your trip')
    end
end
