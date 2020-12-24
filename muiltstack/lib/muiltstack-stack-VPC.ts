import * as cdk from '@aws-cdk/core';
import * as ec2 from '@aws-cdk/aws-ec2';
import { Tag, CfnOutput } from '@aws-cdk/core';

export class MuiltstackStackVPC extends cdk.Stack {
  readonly tempvpc: ec2.IVpc;

  constructor(scope: cdk.Construct, id: string, props: cdk.StackProps) {
    super(scope, id, props);
    

    // stack tag
    Tag.add(this, 'key', 'volume');

    // VPC & Subnet
  this.tempvpc = new ec2.Vpc (this, 'tempvpc', {
      maxAzs: 3,
      natGateways: 0,
      cidr: '172.16.0.0/16',
      subnetConfiguration: [
        {
          cidrMask: 24,
          name: 'ingress',
          subnetType: ec2.SubnetType.PUBLIC,
          
        },
        {
          cidrMask: 24,
          name: 'application',
          subnetType: ec2.SubnetType.ISOLATED,
        },
        {
          cidrMask: 24,
          name: 'rds',
          subnetType: ec2.SubnetType.ISOLATED,
        }
      ]  
    });

   
  }
}
