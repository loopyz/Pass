/* Drop pets with inactive users after seven days. */
Parse.Cloud.job('dropInactivePets', function(request, status) {
  status.message('Starting job: dropInactivePets');

  Parse.Cloud.useMasterKey();
  var INACTIVE_LIMIT = 7; // number of days before pet is dropped
  var expiration = new Date();
  expiration.setDate(expiration.getDate() - INACTIVE_LIMIT);

  var query = new Parse.Query(Parse.Object.extend('Pet'));
  query.include('currentUser').each(function(pet) {
    var user = pet.get('currentUser');
    if (user && user.get('lastActiveAt') < expiration) {
      // TODO: Send a message to user telling them their pet was dropped.
      status.message('Dropping pet: ' + pet.get('name'));
      pet.set('currentUser', null);
      pet.increment('passes');
      return pet.save();
    }
    return true;
  }).then(function() {
    status.success('Job ran successfully.');
  }, function(error) {
    status.error('Error: ' + error.toString());
  });

});
