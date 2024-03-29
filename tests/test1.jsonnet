local kube = import '../k8s.libsonnet';

[
  kube.PersistentVolumeClaim(
    name='pvc1',
  ),
  kube.Deployment(
    name='',
    labels=[],
    podTemplate=kube.PodTemplate(
      containers=[],
      volumes=[
        kube.Volume(
          name='vol1',
          claimName='pvc1',
        ),
      ],
    ),
  ),
]
