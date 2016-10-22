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
    [changeEmail dismissViewControllerAnimated:YES completion:nil];
  }];
  [changeEmail addAction:ok];
  [self presentViewController:changeEmail animated:YES completion:nil];
  [user updateEmail:changeEmail.textFields.firstObject.text completion:^(NSError *_Nullable error) {
    if (error) {
      // An error happened.
      NSLog(@"Couldn't update email");
      UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Error" message:@"Could not update email, please try again" preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [error dismissViewControllerAnimated:YES completion:nil];
      }];
      [error addAction:ok];
      [self presentViewController:error animated:YES completion:nil];
    } else {
      // Email updated.
    }
  }];
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
