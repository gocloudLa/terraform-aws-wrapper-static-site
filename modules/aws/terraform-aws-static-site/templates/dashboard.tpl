{
    "widgets": [
        {
            "type": "metric",
            "x": 0,
            "y": 0,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/CloudFront", "Requests", "Region", "Global", "DistributionId", "${CLOUDFRONT_DISTRIBUTION_ID}" ]
                ],
                "region": "${AWS_REGION_CLOUDFRONT}",
                "title": "CloudFront: requests sum",
                "yAxis": {
                    "left": {
                        "showUnits": false
                    },
                    "right": {
                        "showUnits": false
                    }
                },
                "stat": "Sum"
            }
        },
        {
            "type": "metric",
            "x": 6,
            "y": 0,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/CloudFront", "BytesUploaded", "Region", "Global", "DistributionId", "${CLOUDFRONT_DISTRIBUTION_ID}" ],
                    [ ".", "BytesDownloaded", ".", ".", ".", "." ]
                ],
                "region": "${AWS_REGION_CLOUDFRONT}",
                "title": "CloudFront: data transfer",
                "yAxis": {
                    "left": {
                        "showUnits": false
                    },
                    "right": {
                        "showUnits": false
                    }
                }
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 0,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/CloudFront", "TotalErrorRate", "Region", "Global", "DistributionId", "${CLOUDFRONT_DISTRIBUTION_ID}" ],
                    [ ".", "4xxErrorRate", ".", ".", ".", ".", { "label": "Total4xxErrors" } ],
                    [ ".", "5xxErrorRate", ".", ".", ".", ".", { "label": "Total5xxErrors" } ]
                ],
                "region": "${AWS_REGION_CLOUDFRONT}",
                "title": "CloudFront: 4xx/5xx % errors",
                "yAxis": {
                    "left": {
                        "showUnits": false
                    },
                    "right": {
                        "showUnits": false
                    }
                }
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 6,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/S3", "NumberOfObjects", "StorageType", "AllStorageTypes", "BucketName", "${S3_BUCKET_NAME}", { "period": 86400 } ],
                    [ ".", "BucketSizeBytes", ".", "StandardStorage", ".", ".", { "period": 86400 } ]
                ],
                "region": "${AWS_REGION_BUCKET}",
                "title": "S3: size & number of objects"
            }
        },
        {
            "height": 6,
            "width": 6,
            "y": 6,
            "x": 6,
            "type": "metric",
            "properties": {
                "metrics": [
                    [ "AWS/S3", "AllRequests", "BucketName", "${S3_BUCKET_NAME}", "FilterId", "${S3_ENHANCE_METRIC_NAME}"],
                    [ ".", "PutRequests", ".", ".", ".", "." ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${AWS_REGION_BUCKET}",
                "title": "S3: total request",
                "period": 300,
                "stat": "Sum"
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 6,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/S3", "4xxErrors", "BucketName", "${S3_BUCKET_NAME}", "FilterId", "${S3_ENHANCE_METRIC_NAME}" ],
                    [ ".", "5xxErrors", ".", ".", ".", "." ]
                ],
                "region": "${AWS_REGION_BUCKET}",
                "title": "S3: 4xx/5xx % errors"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 6,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/S3", "BytesDownloaded", "BucketName", "${S3_BUCKET_NAME}", "FilterId", "${S3_ENHANCE_METRIC_NAME}" ]
                ],
                "region": "${AWS_REGION_BUCKET}",
                "title": "S3: bytes downloaded"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 6,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": true,
                "start": "-P1H",
                "end": "P0D",
                "region": "${AWS_REGION_BUCKET}",
                "metrics": [
                    [ "AWS/S3", "TotalRequestLatency", "BucketName", "${S3_BUCKET_NAME}", "FilterId", "${S3_ENHANCE_METRIC_NAME}" ]
                ],
                "period": 60,
                "stat": "Average",
                "title": "S3: total request latency"
            }
        }

    ]
}