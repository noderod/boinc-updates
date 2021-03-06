"""
BASICS


Interactions with VolCon mirrors
"""


import mysql_interactions as mints
import os
import random
import redis
import requests


r = redis.Redis(host = '0.0.0.0', port = 6389, db = 3)



# Chooses a random mirror
# Returns the IP
def get_random_mirror():

    K = [H.decode("UTF-8") for H in r.hkeys("VolCon")]
    H = [h for h in K if "M-"==h[:2]]
    random.shuffle(H)

    return H[0][2:]



# Returns the key of random mirror
def mirror_key(mirror_IP):
    return r.hget("M-"+mirror_IP, "disconnect-key").decode("UTF-8")



# Uploads job information to a random mirror, only valid for TACC or public images
# User may provide any information except the key
# JOB_INFO (dict): Contains any infromation about the job

def upload_job_to_mirror(JOB_INFO):


    mirror_ip = get_random_mirror()

    JOB_INFO["key"] = mirror_key(get_random_mirror())

    mints.update_mirror_ip(JOB_INFO["VolCon_ID"], mirror_ip)
    # Updates result to mirror
    requests.post('http://'+mirror_ip+":7000/volcon/mirror/v2/api/public/receive_job_files",
        json=JOB_INFO)

    # Calls own server to update the new status
    requests.post('http://'+os.environ["SERVER_IP"]+":5089/volcon/v2/api/mirrors/status/update",
        json=JOB_INFO)




