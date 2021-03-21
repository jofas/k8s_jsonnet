{
  Labels(app, environment, version=null):
    {
      app: app,
      environment: environment,
    }
    +
    if version == null then {} else {
      version: version,
    },

  name(app, environment, version=null):
    if version == null then
      std.format('%s-%s', [app, environment])
    else
      std.format('%s-v%s-%s', [app, version, environment]),

  image(image, version):
    std.format('%s:v%s', [image, std.strReplace(version, '-', '.')]),
}
