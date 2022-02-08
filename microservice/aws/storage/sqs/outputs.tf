output "arn" {
  value = "${aws_sqs_queue.queue_wo_dql.arn}"
}