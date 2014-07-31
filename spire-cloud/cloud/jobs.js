/* Drop pets that have not changed ownership after seven days. */
Parse.Cloud.job('dropInactivePets', function(request, status) {
  status.message('Running job: dropInactivePets');
  // TODO: implement me
  status.success('0 pets dropped!');
});
