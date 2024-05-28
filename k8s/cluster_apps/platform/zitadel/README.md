### Create a new project and application in zitadel
1. Select " Projects Tab" and click "Create new project" 
2. Add a new name for the project eg: homelab
3. In the newly created project page make sure the following 2 items are enabled and click "save"
    ```
    Assert Roles on Authentication
    Check authorization on Authentication
    ```
4. In the same project page click the icon "New" to create a new application
5. Add a name for the new application. eg: webapp and click continue 
6. In the authentication method selections page, select  "CODE" and click continue
7. In the next page , add the "redirectUrl" eg: https://dex.dev.local/callback and click continue
8. Click "create" to finalize the configurations
9. A new window pops with the clientId and clientSecret. copy the values to safe location
10. In the newly created application page , select "Token settings" from the right panel
11. In the token settings sections make sure the following 2 items are enabled and click "save"
    ```
    User roles inside ID Token
    User Info inside ID Token
    ```

### create new roles in zitadel
1. Select the project you have created previously and click the "roles" setting from right panel
2. Select "New" and create a new role with the details for new role
    eg:
    ```
    Key: administrator
    Display name: administrator
    Group: administrator
    ```
    you can create two roles administrator and users

### create users and assign user roles
1. Select "users" tab from the top navigation and click "new" to create a new user(make sure user type is "Humans")
2. Fill the user details and click create 
3. To add users to role , navigate back to project page and select "Authorizations" from the right panel 
4. Click new and add the select user and click continue and select the role for the user and click "save"

### add zitadel action script to include groups claim to the token
1. Select "Actions" tab from the top navigation and click "new" in scripts section
2. Add the following details and click "Add"
    ```
    Name: groupsClaim
    ```
    ```
    function groupsClaim(ctx, api) {
    if (ctx.v1.user.grants === undefined || ctx.v1.user.grants.count == 0) {
        return;
    }

    let grants = [];
    ctx.v1.user.grants.grants.forEach(claim => {
        claim.roles.forEach(role => {
            grants.push(role)  
        })
    })

    api.v1.claims.setClaim('groups', grants)
    }
    ```
3. Configure Flow by selecting "Complement Token" from FlowType dropdown and click "Add trigger" button
4. In the popup window , select "Pre Userinfo creation" from TriggerType dropdown
5. Select above created action "groupsClaim" in Actions section and click save
6. Repeat the process and configure another Trigger for "Pre access token creation"

### [Optional] Configuring dex project to use zitadel as identity provider 
make sure to update the ZITADEL_CLIENT_ID and ZITADEL_CLIENT_SECRET with the clientId and clientSecret generated while creating new zitadel project 

