#!/usr/bin/env node
import 'source-map-support/register';
import * as cdk from '@aws-cdk/core';
import { MuiltstackStackVPC } from '../lib/muiltstack-stack-VPC';
import { MuiltstackStackec2 } from '../lib/muiltstack-stack-ec2';
import { config } from '../lib/env';

const app = new cdk.App();

const VPCStack = new MuiltstackStackVPC(app, 'MuiltstackStackVPC',{
    env: config
});


const ec2Stack = new MuiltstackStackec2(app, 'MuiltstackStackec2',{
    vpc: VPCStack.tempvpc,
    env: config
});
ec2Stack.addDependency(VPCStack);