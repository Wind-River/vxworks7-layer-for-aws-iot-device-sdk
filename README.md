# VxWorks® 7 Client for AWS IoT Device SDK

## Overview

This document provides a quick summary of how to build and run the **Amazon Web Services (AWS) Internet of Things (IoT)** device software development kit (SDK) for C that resides in VxWorks 7 on your device. The SDK is an embedded C client library for interacting with the AWS IoT platform. This client library is not provided in VxWorks 7 RPM packages or on the VxWorks 7 product DVDs. You need to manually install this library on VxWorks 7.

Release note: The version 1.0.0.x has been validated with VxWorks 7 SR0610.

### Project License

The license for this project is the MIT license. Text of MIT license and other applicable license notices can be found in the LICENSE_NOTICES.txt file in the top level directory. Each source files should include a license notice that designates the licensing terms for the respective file. 

### Prerequisite

You must have an AWS account to try the samples.  To create a free account on AWS please visit https://aws.amazon.com/ and click the "Create a Free Account" button.

Before installing the SDK prepare the development environment.    
1. Install git and ensure it operates from the command line.  
2. Install cmake and ensure it operates from the command line.
3. Ensure the VxWorks 7 DVD is installed.  
4. Ensure the **AWS IoT** device SDK for C source code is available from the following location:

   https://github.com/aws/aws-iot-device-sdk-embedded-C.git

## Installing the SDK

1. Download the **VxWorks 7 AWS IoT SDK** layer from the following location:

   https://github.com/Wind-River/vxworks7-layer-for-aws-iot-device-sdk.git

2. Set WIND_LAYER_PATHS to point to the vxworks7-layer-for-aws-iot-sdk-c directory. Command-line users may set this directly using export on Linux or set on Windows. Developers working on a Microsoft Windows host may also set the system environment variables. On Microsoft Windows 10, these can be found in the Control Panel under View advanced system Settings. Click the "Advanced" tab to find the "Environment Variables" button. From here you may set WIND_LAYER_PATHS to point to the vxworks7-layers-for-aws-iot-sdk-c. Please refer to the VxWorks documentation for details on the WIND_LAYER_PATHS variable.
2. Confirm the layer is present in your VxWorks 7 installation.
    In a VxWorks development shell, you may run "vxprj vsb listAll" and look for AWS_IOT_SDK_1_0_0_0 to confirm that the layer has been found.

## Creating the VSB and VIP Using WrTool

Create the VxWorks 7 VxWorks source build (VSB) and VxWorks image project (VIP) using either the Wind River Workbench environment or the command line tool **WrTool**. This procedure uses the *vxsim_linux* board support package (BSP) as an example.  

1. Set the environment variable and change the directory.

        export WIND_WRTOOL_WORKSPACE=$HOME/WindRiver/workspace   
        cd $WIND_WRTOOL_WORKSPACE

2. Create the VSB using the **WrTool**.

        wrtool prj vsb create -force -bsp vxsim_linux myVSB -S
        cd myVSB
        wrtool prj vsb add AWS_IOT_SDK
        make -j[jobs]  <-- set the number of parallel build jobs, typically 2, 4, 8
        cd ..

3. Create the VIP using the **WrTool**.

        wrtool prj vip create -force -vsb myVSB -profile PROFILE_STANDALONE_DEVELOPMENT vxsim_linux llvm myVIP
        cd myVIP
        wrtool prj vip component add INCLUDE_SHELL INCLUDE_NETWORK INCLUDE_IFCONFIG INCLUDE_PING INCLUDE_IPDNSC
        wrtool prj vip component add INCLUDE_POSIX_PTHREAD_SCHEDULER  INCLUDE_DEFAULT_TIMEZONE
        wrtool prj vip parameter set DNSC_PRIMARY_NAME_SERVER   "\"1.1.1.1\""
        wrtool prj vip parameter set DNSC_SECONDARY_NAME_SERVER "\"1.0.0.1\""
        cd ..

The test sample is provided in the AWS IoT SDK as *demos/source/iot_demo_mqtt.c*. It can be used to connect your device to the AWS IoT cloud, publish telemetry to the cloud and to receive commands from the AWS IoT cloud. To enable this sample, you need to create an RTP project.

## Creating the RTP Using WrTool

1. Create an RTP project based on myVSB.

        wrtool prj rtp create -vsb myVSB myRTP

2. Add the file for iot_demo_mqtt.

        wrtool prj file add $WIND_WRTOOL_WORKSPACE/myVSB/3pp/AWS_IOT_SDK/src/demos/source/iot_demo_mqtt.c

3. Delete the sample rtp.c file

        wrtool prj file delete rtp.c

4. Add additional sample source code files.

        wrtool prj file add $WIND_WRTOOL_WORKSPACE/myVSB/3pp/AWS_IOT_SDK/src/demos/app/posix/iot_demo_arguments_posix.c
        wrtool prj file add $WIND_WRTOOL_WORKSPACE/myVSB/3pp/AWS_IOT_SDK/src/demos/app/posix/iot_demo_posix.c

5. Add the configuration header file.

        wrtool prj file add $WIND_WRTOOL_WORKSPACE/myVSB/3pp/AWS_IOT_SDK/src/demos/iot_config.h

6. Add the include directories.

        wrtool prj include add '-I$(PRJ_ROOT_DIR)' myRTP
        wrtool prj include add '-I$(VSB_DIR)/share/h' myRTP
        wrtool prj include add '-I$(VSB_DIR)/3pp/AWS_IOT_SDK/demos/include' myRTP
        wrtool prj include add '-I$(VSB_DIR)/3pp/AWS_IOT_SDK/platform/include' myRTP
        wrtool prj include add '-I$(VSB_DIR)/3pp/AWS_IOT_SDK/lib/include' myRTP

5. Add the usr/lib/common library directory.

        wrtool prj lib add '-L$(VSB_DIR)/usr/root/llvm/bin' myRTP

6. Add the static library dependencies.

        wrtool prj lib add '-lunix' myRTP
        wrtool prj lib add '-lnet' myRTP
        wrtool prj lib add '-lOPENSSL' myRTP
        wrtool prj lib add '-lHASH' myRTP
        wrtool prj lib add '-liotcommon' myRTP
        wrtool prj lib add '-liotplatform' myRTP
        wrtool prj lib add '-liotmqtt' myRTP

7. Add the macro definitions.

        wrtool prj define add '-DRunDemo=RunMqttDemo' myRTP
        wrtool prj define add '-DIOT_SYSTEM_TYPES_FILE=\"posix/iot_platform_types_posix.h\"' myRTP

8. Follow the instructions on the "Getting Started with AWS IoT" to set up the AWS IoT service.

    https://docs.aws.amazon.com/iot/latest/developerguide/iot-gs.html

9. Open the iot_config.h file you copied into your RTP.

    To create a connection to a registered **Thing**, set the parameters in the file *iot_config.h*.

```
/* Server endpoints used for the demos. May be overridden with command line
 * options at runtime. */
#define IOT_DEMO_SECURED_CONNECTION    ( true ) /* Command line: -s (secured) or -u (unsecured) */
#define IOT_DEMO_SERVER                "yourserver.iot.us-west-2.amazonaws.com"       /* Command line: -h */
#define IOT_DEMO_PORT                  ( 443 )  /* Command line: -p */

/* Credential paths. May be overridden with command line options at runtime. */
#define IOT_DEMO_ROOT_CA               "rootCA.crt" /* Command line: -r */
#define IOT_DEMO_CLIENT_CERT           "cert.pem" /* Command line: -c */
#define IOT_DEMO_PRIVATE_KEY           "privkey.pem" /* Command line: -k */
```

10. Copy the AWS endpoint listed under the Interact page for your Thing.
11. Paste the AWS endpoint into the IOT_DEMO_SERVER macro in iot_config.h
12. Set IOT_DEMO_ROOT_CA, IOT_DEMO_CLIENT_CERT, and IOT_DEMO_PRIVATE_KEY to correspond to the files you downloaded when you created a certificate for your thing.
13. Build the RTP

        wrtool prj build myRTP

14. Deploy it to your target with the certificate files.

  **NOTE:** The values of the the parameters must be consistent with the information of the **Thing** registered in the *AWS IoT* platform. Refer to the SDK guide to create your **Thing**, key pair and certificate files. Put those certificate files in the working directory where you execute the RTP.

## Viewing the Device Information on the AWS IoT Dashboard

You can run your device image with the AWS IoT SDK and then view the device
information dashboard at the AWS IoT website.

* For information on what AWS IoT is, see the following information:

    http://docs.aws.amazon.com/iot/latest/developerguide/what-is-aws-iot.html

* For information on how to use the C SDK, see the following information:
    http://docs.aws.amazon.com/iot/latest/developerguide/iot-device-sdk-c.html

### Legal Notices

All product names, logos, and brands are property of their respective owners. All company, product and service names used in this software are for identification purposes only. Wind River and VxWorks are a registered trademarks of Wind River Systems. Amazon and AWS are registered trademarks of the Amazon Corporation.

Disclaimer of Warranty / No Support: Wind River does not provide support and maintenance services for this software, under Wind River’s standard Software Support and Maintenance Agreement or otherwise. Unless required by applicable law, Wind River provides the software (and each contributor provides its contribution) on an “AS IS” BASIS, WITHOUT WARRANTIES OF ANY KIND, either express or implied, including, without limitation, any warranties of TITLE, NONINFRINGEMENT, MERCHANTABILITY, or FITNESS FOR A PARTICULAR PURPOSE. You are solely responsible for determining the appropriateness of using or redistributing the software and assume ay risks associated with your exercise of permissions under the license.
