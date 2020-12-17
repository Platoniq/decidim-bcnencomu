# bcnencomu

![Test](https://github.com/Platoniq/decidim-bcnencomu/workflows/Test/badge.svg)

Free Open-Source participatory democracy, citizen participation and open government for cities and organizations

This is the open-source repository for bcnencomu, based on [Decidim](https://github.com/decidim/decidim).

## Setting up the application

You will need to do some steps before having the app working properly once you've deployed it:

1. Open a Rails console in the server: `bundle exec rails console`
2. Create a System Admin user:

```ruby
user = Decidim::System::Admin.new(email: <email>, password: <password>, password_confirmation: <password>)
user.save!
```

3. Visit `<your app url>/system` and login with your system admin credentials
4. Create a new organization. Check the locales you want to use for that organization, and select a default locale.
5. Set the correct default host for the organization, otherwise the app will not work properly. Note that you need to include any subdomain you might be using.
6. Fill the rest of the form and submit it.

You're good to go!

## The Assembly duplicator hack

PR #15 introduces an experimental feature that allows to add an alternative Assemblies menu.
It uses the Assemblies types to divide the assemblies into the original and the different alternative menus.

For instance, imagine you have these assembly types:

- Governance [Assembly Type ID: 12]
- Participation [Assembly Type ID: 17]
- Others [Assembly Type ID: 9]

And these assemblies with these types assigned:

- Assembly 1 (Assembly Type ID: 12)
- Assembly 2 (Assembly Type ID: 17)
- Assembly 3 (no Assembly Type assigned)

And, finally, let's imagine we have configured that types "Participation (17)" and "Others (9)" should be in a different main menu than the normal "ASSEMBLIES", called for instance "PARTICIPATIVE ASSEMBLIES".

Now "Assembly 1" and "Assembly 3" will be listed under the normal "ASSEMBLIES" menu, but "Assembly 2" will not.

Then, another menu item will appear next to "ASSEMBLIES" called "PARTICIPATIVE ASSEMBLIES", when clicking on it, the user will see only the assemblies assigned to types 17 and 9, in this case only the "Assembly 2".

Finally, incorrect routes will be automatically redirected to the correct ones.

### configuration

It is configured via the `secrets.yml` file in a new section `assemblies_types`:

```yaml
default: &default
  assemblies_types:
    -
      key: organs # used to search a I18n key and a route path
      position: 2.6
      types: [17]
```

- **assemblies_types**: must be an array in YAML format, each entry will correspond to a new entry in the main Decidim menu next to the "ASSEMBLIES" item.
- **key**: the identifier for the menu and URL path. For instance, if it is `organs` we will have a new menu entry for the url `URL/organs` and the name specified in the I18n key ``bcnencomu.assemblies_types.organs`.
- **position**: Where to place the item in the main menu, the usual "ASSEMBLIES" item have the value `2.5`, lower this number will put it before and vice-versa.
- **types**: and array of IDs for the model `Decidim::AssembliesType`. All assemblies assigned to this ID will be listed here and not in the normal "ASSEMBLIES" menu.