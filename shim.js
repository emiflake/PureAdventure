async function handle_command(cmd, args) {
  const retval = await PS["Main"].handle_command(cmd)(args)();
  game_log("finished handle_command");
  return retval;
};
