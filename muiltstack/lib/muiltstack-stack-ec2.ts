import * as cdk from '@aws-cdk/core';
import * as ec2 from '@aws-cdk/aws-ec2';
import { Tag, Tags, CfnOutput } from '@aws-cdk/core';
import { readFileSync } from 'fs';
import * as iam from '@aws-cdk/aws-iam';
import { MuiltstackStackVPC } from './muiltstack-stack-VPC';

interface ec2StackProps extends cdk.StackProps {
  vpc: ec2.IVpc;
}

export class MuiltstackStackec2 extends cdk.Stack {
  readonly vpc: ec2.IVpc;

  constructor(scope: cdk.Construct, id: string, props: ec2StackProps ) {
    super(scope, id, props);


    // 套用vpc stack的vpc
    const vpc = props.vpc;

    // 整個stack的tag
    Tag.add(this, 'key', 'volume');

    //stack的tag
    Tags.of(this).add('key', 'volume');


    // userdata
    var installdocker: string;
    installdocker = readFileSync('./lib/shell/installdocker.sh', 'utf8');

    // ec2 with aws ami
    const sampleec2 = new ec2.Instance(this , 'sampleec2name' ,{
      vpc: this.vpc,
      vpcSubnets: {
        subnetType: ec2.SubnetType.PUBLIC
      },
      instanceType: ec2.InstanceType.of(ec2.InstanceClass.T3 , ec2.InstanceSize.MICRO),
      machineImage: new ec2.AmazonLinuxImage({}),
      keyName: 'keypair',
      blockDevices: [({ deviceName: '/dev/xvda', volume: ec2.BlockDeviceVolume.ebs(60) })],
    });
    sampleec2.addUserData(installdocker);
    sampleec2.role.addManagedPolicy(iam.ManagedPolicy.fromAwsManagedPolicyName('AmazonSSMManagedInstanceCore'));
    sampleec2.connections.allowFrom(ec2.Peer.ipv4('172.168.0.0/0'), ec2.Port.tcp(22), 'allow ssh from ');


    // ec2 with custom ami
    const CustomEC2 = new ec2.Instance(this, 'CustomEC2', {
      vpc,
      vpcSubnets: {
        subnetType: ec2.SubnetType.PUBLIC,
      },
      instanceType: ec2.InstanceType.of(ec2.InstanceClass.T3, ec2.InstanceSize.XLARGE),
      machineImage: ec2.MachineImage.lookup({
        name: 'amzn2-ami-hvm-2.0.20200406.0-x86_64-gp2',
      }),
      keyName: 'keyname',
      blockDevices: [({ deviceName: '/dev/xvda', volume: ec2.BlockDeviceVolume.ebs(60) })],
    });
    CustomEC2.addUserData(installdocker);
    CustomEC2.role.addManagedPolicy(iam.ManagedPolicy.fromAwsManagedPolicyName('AmazonSSMManagedInstanceCore'));
    CustomEC2.connections.allowFrom(ec2.Peer.ipv4('172.168.0.0/0'), ec2.Port.tcp(22), 'allow ssh from ');

  }
}
