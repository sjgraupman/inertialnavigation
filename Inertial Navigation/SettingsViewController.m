//
//  SettingsViewController.m
//  Inertial Navigation
//
//  Created by Kristen Kozmary on 10/13/16.
//  Copyright © 2016 koz. All rights reserved.
//

#import <Foundation/Foundation.h>
@import Firebase;
#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (nonatomic, weak) NSString *email;
@property (nonatomic, weak) NSString *password;

@end



@implementation SettingsViewController

- (IBAction)didTapLogout:(id)sender {
  
  NSError *signOutError;
  BOOL status = [[FIRAuth auth] signOut:&signOutError];
  if (!status) {
    NSLog(@"Error signing out: %@", signOutError);
    return;
  }
  [self performSegueWithIdentifier:@"LogoutSegue" sender:nil];

}

- (IBAction)didTapChangeEmail:(id)sender {
  FIRUser *user = [FIRAuth auth].currentUser;
  UIAlertController *changeEmail = [UIAlertController alertControllerWithTitle:nil message:@"Enter new email address" preferredStyle:UIAlertControllerStyleAlert];
  [changeEmail addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    textField.placeholder = @"example@inertialnav.com";
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
  }];
  UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    [user updateEmail:changeEmail.textFields.firstObject.text completion:^(NSError *_Nullable error) {
      if (error) {
        // An error happened.
        NSLog(@"Couldn't update email");
        UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Error" message:@"Could not update email, please try again" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          // [error dismissViewControllerAnimated:YES completion:nil];
        }];
        [error addAction:ok];
        [self presentViewController:error animated:YES completion:nil];
      } else {
        UIAlertController *emailUpdated = [UIAlertController alertControllerWithTitle:@"Email updated" message:@"Please sign in again with new email address" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
          NSError *signOutError;
          BOOL status = [[FIRAuth auth] signOut:&signOutError];
          if (!status) {
            NSLog(@"Error signing out: %@", signOutError);
            return;
          }
          UIAlertController *credentials = [UIAlertController alertControllerWithTitle:@"Sign In" message:nil preferredStyle:UIAlertControllerStyleAlert];
          [credentials addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull emailField) {
            emailField.placeholder = @"Email";
            emailField.clearButtonMode = UITextFieldViewModeWhileEditing;
              _email = emailField.text;
          }];
          [credentials addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull passwordField) {
            passwordField.placeholder = @"Password";
            passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
              _password = passwordField.text;
          }];

          UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            FIRUser *user = [FIRAuth auth].currentUser;
            FIRAuthCredential *credential;
            //credential = FIREmailPasswordAuthProvider.credentialWithEmail(_email, password: _password)
            //+ (FIRAuthCredential *)credentialWithEmail:(NSString *)email password:(NSString *)password;
            // Prompt the user to re-provide their sign-in credentials
            [user reauthenticateWithCredential:credential completion:^(NSError *_Nullable error) {
              if (error) {
                // An error happened.
              } else {
                // User re-authenticated.
              }
            }];
            [self.navigationController popToRootViewControllerAnimated:YES];
          }];
          [credentials addAction:ok];
          [self presentViewController:credentials animated:YES completion:nil];
                  //[self performSegueWithIdentifier:@"LogoutSegue" sender:nil];
          
        }];
        [emailUpdated addAction:ok];
        [self presentViewController:emailUpdated animated:YES completion:nil];
        // Email updated.
      }
    }];
  }];
  [changeEmail addAction:ok];
  [self presentViewController:changeEmail animated:YES completion:nil];
  

 // FIRAuthCredential *credential;
  
  // Prompt the user to re-provide their sign-in credentials
  
 // [user reauthenticateWithCredential:credential completion:^(NSError *_Nullable error) {
    //if (error) {
     // // An error happened.
   // } else {
    //  // User re-authenticated.
  //  }
 // }];
}

- (IBAction)didTapChangePassword:(id)sender {
  NSString *email = [FIRAuth auth].currentUser.email;

  [[FIRAuth auth] sendPasswordResetWithEmail:email
                                  completion:^(NSError *_Nullable error) {
                                    if (error) {
                                      // An error happened.
                                    } else {
                                      // Password reset email sent.
                                      UIAlertController *resetEmail = [UIAlertController alertControllerWithTitle:nil message:@"Password reset request sent. Please check your email." preferredStyle:UIAlertControllerStyleAlert];
                                      UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                        [resetEmail dismissViewControllerAnimated:YES completion:nil];
                                      }];
                                      [resetEmail addAction:ok];
                                      [self presentViewController:resetEmail animated:YES completion:nil];
                                      
                                      NSError *signOutError;
                                      BOOL status = [[FIRAuth auth] signOut:&signOutError];
                                      if (!status) {
                                        NSLog(@"Error signing out: %@", signOutError);
                                        return;
                                      }

                                    }
                                  }];
  [self performSegueWithIdentifier:@"LogoutSegue" sender:nil];

}

- (IBAction)didTapDeleteAccount:(id)sender {
  FIRUser *user = [FIRAuth auth].currentUser;
  UIAlertController *deleteAccount = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure you want to delete your account? All data will be erased" preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      [user deleteWithCompletion:^(NSError *_Nullable error) {
        if (error) {
          // An error happened.
        } else {
          //account deleted
          [self performSegueWithIdentifier:@"LogoutSegue" sender:nil];
        }
    }];
  }];
      
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
      [deleteAccount dismissViewControllerAnimated:YES completion:nil];
    }];
    [deleteAccount addAction:ok];
    [deleteAccount addAction:cancel];
    [self presentViewController:deleteAccount animated:YES completion:nil];

  
//  dispatch_async(dispatch_get_main_queue(), ^{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//  });
  //[self.navigationController popToRootViewControllerAnimated:YES];
 //[self performSegueWithIdentifier:@"LogoutSegue" sender:nil];
}






@end
