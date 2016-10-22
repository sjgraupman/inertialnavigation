//
//  Copyright (c) 2016 Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//  Firebase's Friendly Chat Codelab was used as a skeleton for this project

#import "SignInViewController.h"
#import "AppState.h"
#import "Measurements.h"
#import "Constants.h"
@import Firebase;



@interface SignInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation SignInViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}


- (void)viewDidAppear:(BOOL)animated {
  FIRUser *user = [FIRAuth auth].currentUser;
  if (user) {
    [self signedIn:user];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}





- (IBAction)didTapSignIn:(id)sender {
  // Sign In with credentials.
  NSString *email = _emailField.text;
  NSString *password = _passwordField.text;
  [[FIRAuth auth] signInWithEmail:email
                         password:password
                       completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                         if (error) {
                           NSLog(@"%@", error.localizedDescription);
                           return;
                         }
                        // [self signedIn:user];
//                         if (emailVerified == true) {
//                           
//                         }
                         if ([FIRAuth auth].currentUser.emailVerified) {
                           [self signedIn:user];
                            [self performSegueWithIdentifier:@"SegueToMap" sender:nil];
                         } else {
                           UIAlertController *signInError = [UIAlertController alertControllerWithTitle:@"Error" message:@"Could not sign in. Please try again." preferredStyle:UIAlertControllerStyleAlert];
                           UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                             [signInError dismissViewControllerAnimated:YES completion:nil];
                           }];
                           [signInError addAction:ok];
                           [self presentViewController:signInError animated:YES completion:nil];
                         }
                        
                       }];
}

- (IBAction)didTapSignUp:(id)sender {
  NSString *email = _emailField.text;
  NSString *password = _passwordField.text;
//  FIRUser *user = [FIRAuth auth].currentUser;
  [[FIRAuth auth] createUserWithEmail:email
                             password:password
                           completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                             if (error) {
                               NSLog(@"%@", error.localizedDescription);
                               return;
                             }
                             [self setDisplayName:user];
                             
                             UIAlertController *accountCreated = [UIAlertController alertControllerWithTitle:@"Account Created" message:@"Your account was successfully created. Please check your email and verify with the provided link" preferredStyle:UIAlertControllerStyleAlert];
                             
                             UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                               [accountCreated dismissViewControllerAnimated:YES completion:nil];
                             }];
                             
                             [accountCreated addAction:ok];
                             [self presentViewController:accountCreated animated:YES completion:nil];
                             
                             [[FIRAuth auth] signInWithEmail:email
                                                    password:password
                                                  completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
                                                    if (error) {
                                                      NSLog(@"%@", error.localizedDescription);
                                                      return;
                                                    }
                                                    [self signedIn:user];
                                                    [user sendEmailVerificationWithCompletion:^(NSError * _Nullable error) {
                                                      if (error) {
                                                        NSLog(@"%@ COULD NOT SEND EMAIL", error.localizedDescription);
                                                      } else {
                                                        //email sent
                                                        NSLog(@"EMAIL SENT");
                                                        NSError *signOutError;
                                                        BOOL status = [[FIRAuth auth] signOut:&signOutError];
                                                        if (!status) {
                                                          NSLog(@"Error signing out: %@", signOutError);
                                                          return;
                                                        }
                                                      }
                                                    }];
                                                    
                                                  }];
                             

                             
                           }];

}

- (void)setDisplayName:(FIRUser *)user {
  FIRUserProfileChangeRequest *changeRequest =
  [user profileChangeRequest];
  // Use first part of email as the default display name
  changeRequest.displayName = [[user.email componentsSeparatedByString:@"@"] objectAtIndex:0];
  [changeRequest commitChangesWithCompletion:^(NSError *_Nullable error) {
    if (error) {
      NSLog(@"%@", error.localizedDescription);
      return;
    }
    [self signedIn:[FIRAuth auth].currentUser];
  }];
}

- (IBAction)didRequestPasswordReset:(id)sender {
  UIAlertController *prompt =
  [UIAlertController alertControllerWithTitle:nil
                                      message:@"Email:"
                               preferredStyle:UIAlertControllerStyleAlert];
  __weak UIAlertController *weakPrompt = prompt;
  UIAlertAction *okAction = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * _Nonnull action) {
                               UIAlertController *strongPrompt = weakPrompt;
                               NSString *userInput = strongPrompt.textFields[0].text;
                               if (!userInput.length)
                               {
                                 return;
                               }
                               [[FIRAuth auth] sendPasswordResetWithEmail:userInput
                                                               completion:^(NSError * _Nullable error) {
                                                                 if (error) {
                                                                   NSLog(@"%@", error.localizedDescription);
                                                                   return;
                                                                 }
                                                               }];
                               
                             }];
  [prompt addTextFieldWithConfigurationHandler:nil];
  [prompt addAction:okAction];
  [self presentViewController:prompt animated:YES completion:nil];
}

- (void)signedIn:(FIRUser *)user {
  [Measurements sendLoginEvent];
  
  [AppState sharedInstance].displayName = user.displayName.length > 0 ? user.displayName : user.email;
  [AppState sharedInstance].signedIn = YES;
  [[NSNotificationCenter defaultCenter] postNotificationName:NotificationKeysSignedIn
                                                      object:nil userInfo:nil];
  //[self performSegueWithIdentifier:SegueToMap sender:nil];
}






@end
