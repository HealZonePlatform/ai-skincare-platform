// src/lib/emailService.ts
import { trackEvent } from './analytics';

interface EmailData {
  to: string;
  subject: string;
  html: string;
  text?: string;
}

export const sendEmail = async (emailData: EmailData): Promise<boolean> => {
  try {
    // In a real implementation, this would call an email service API
    // For now, we'll simulate the email sending process
    console.log('Sending email:', {
      to: emailData.to,
      subject: emailData.subject,
      html: emailData.html,
      text: emailData.text
    });

    // Simulate API call delay
    await new Promise(resolve => setTimeout(resolve, 500));

    // Track email sending event
    trackEvent('email_sent', 'email', `${emailData.subject} to ${emailData.to}`);

    return true;
  } catch (error) {
    console.error('Error sending email:', error);
    trackEvent('email_failed', 'email', `${emailData.subject} to ${emailData.to}`);
    return false;
  }
};

export const sendEarlyAccessConfirmation = async (email: string, name?: string): Promise<boolean> => {
  const subject = 'Welcome to AI Skincare Early Access Program';
  const html = `
    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
      <h2 style="color: #6d28d9;">Welcome to AI Skincare Early Access Program!</h2>
      <p>Dear ${name || 'Valued Customer'},</p>
      <p>Thank you for signing up for early access to our AI Skincare platform. We're excited to have you on board!</p>
      <p>Our team is working hard to bring you the best AI-powered skincare experience. You'll be among the first to know when our app is ready for download.</p>
      <p>While you wait, feel free to explore our <a href="https://healzoneplatform.github.io/ai-skincare-platform/" style="color: #6d28d9;">website</a> to learn more about our technology and features.</p>
      <p>Best regards,<br>The AI Skincare Team</p>
      <hr style="margin: 20px 0; border: none; border-top: 1px solid #eee;">
      <p style="font-size: 12px; color: #666;">This email was sent to ${email} because you signed up for early access to the AI Skincare platform.</p>
    </div>
  `;

  return sendEmail({
    to: email,
    subject,
    html,
    text: `Welcome to AI Skincare Early Access Program! Thank you for signing up. You'll be notified when our app is ready for download.`
  });
};

export const sendAdminNotification = async (email: string, name?: string): Promise<boolean> => {
  const subject = `New Early Access Signup: ${name || email}`;
  const html = `
    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
      <h2 style="color: #6d28d9;">New Early Access Signup</h2>
      <p>A new user has signed up for early access to the AI Skincare platform:</p>
      <ul>
        <li><strong>Name:</strong> ${name || 'Not provided'}</li>
        <li><strong>Email:</strong> ${email}</li>
        <li><strong>Signup Time:</strong> ${new Date().toISOString()}</li>
      </ul>
      <p>Please log into your admin panel to view all early access requests.</p>
    </div>
  `;

  // In a real implementation, this would be sent to admin emails
  // For this example, we'll send it to the same user email for demonstration
  return sendEmail({
    to: email, // In real app, this would be admin email(s)
    subject,
    html,
    text: `New early access signup from ${name || 'a user'} with email ${email}`
  });
};

// Function to handle complete signup flow with email notifications
export const handleEarlyAccessSignup = async (email: string, name?: string): Promise<{ success: boolean; message: string }> => {
  try {
    // Send confirmation email to user
    const userEmailSent = await sendEarlyAccessConfirmation(email, name);
    
    // Send notification to admin
    const adminEmailSent = await sendAdminNotification(email, name);
    
    if (userEmailSent && adminEmailSent) {
      return {
        success: true,
        message: 'Signup confirmed and notifications sent'
      };
    } else {
      return {
        success: false,
        message: 'Signup processed but there was an issue sending notifications'
      };
    }
  } catch (error) {
    console.error('Error in early access signup flow:', error);
    return {
      success: false,
      message: 'There was an error processing your signup'
    };
  }
};