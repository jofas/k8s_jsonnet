local Service(name, labels, ports, clusterIP=null) = {
  apiVersion: 'v1',
  kind: 'Service',
  metadata: {
    name: name,
    namespace: 'default',
    labels: labels,
  },
  spec: {
    ports: ports,
    selector: labels,
    [if clusterIP != null then 'clusterIP']: clusterIP,
  },
};

local Deployment(name, labels, containers, volumes=[]) = {
  apiVersion: 'apps/v1',
  kind: 'Deployment',
  metadata: {
    name: name,
    namespace: 'default',
    labels: labels,
  },
  spec: {
    replicas: 1,
    selector: {
      matchLabels: labels,
    },
    template: {
      metadata: {
        labels: labels,
      },
      spec: {
        containers: containers,
      },
    },
    volumes: volumes,
  },
};

local StatefulSet(name, labels, serviceName, containers, volumeClaimTemplates) = {
  apiVersion: 'apps/v1',
  kind: 'StatefulSet',
  metadata: {
    name: name,
    namespace: 'default',
    labels: labels,
  },
  spec: {
    replicas: 1,
    serviceName: serviceName,
    selector: {
      matchLabels: labels,
    },
    template: {
      metadata: {
        labels: labels,
      },
      spec: {
        containers: containers,
      },
    },
    volumeClaimTemplates: volumeClaimTemplates,
  },
};

local ConfigMapRef(name) = {
  configMapRef: {
    name: name,
  },
};

local SecretRef(name) = {
  secretRef: {
    name: name,
  },
};

{
  Service(name, labels, ports, clusterIP=null):
    Service(name, labels, ports, clusterIP),
  Deployment(name, labels, containers, volumes=[]): Deployment(name, labels, containers, volumes),
  StatefulSet(name, labels, serviceName, containers, volumeClaimTemplates):
    StatefulSet(name, labels, serviceName, containers, volumeClaimTemplates),
  ConfigMapRef(name): ConfigMapRef(name),
  SecretRef(name): SecretRef(name),
  VolumeClaimTemplate(name): {
    metadata: {
      name: name,
    },
    spec: {
      accessModes: [
        'ReadWriteOnce',
      ],
      resources: {
        requests: {
          storage: '10Gi',
        },
      },
      storageClassName: 'standard',
    },
  },
  PersistentVolumeClaim(name, namespace='default', accessModes=[], storage='1Gi', storageClassName=null): {
    apiVersion: 'v1',
    kind: 'PersistentVolumeClaim',
    metadata: {
      name: name,
      namespace: namespace,
    },
    spec: {
      accessModes: accessModes,
      resources: {
        requests: {
          storage: storage,
        },
      },
      storageClassName: storageClassName,
    },
  },
  Volume(name, claimName, readOnly=false): {
    name: name,
    persistenVolumeClaim: {
      claimName: claimName,
      readOnly: readOnly,
    },
  },
}
