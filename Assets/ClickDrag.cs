using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ClickDrag : MonoBehaviour
{
    public float forceAmmount = 500;

    Rigidbody dragObject;
    Vector3 offset;

    Vector3 orginalPosition;
    float selectionDistance;

    public GameObject marker;

    private void Update()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);

        if (Input.GetMouseButtonDown(0))
        { 
            RaycastHit hit;

            if(Physics.Raycast(ray,out hit, Mathf.Infinity))
            {
                selectionDistance = Vector3.Distance(ray.origin, hit.point);

                dragObject = hit.rigidbody;
                offset = Camera.main.ScreenToWorldPoint(new Vector3(Input.mousePosition.x,
                    Input.mousePosition.y,
                    selectionDistance));
                orginalPosition = hit.collider.transform.position;
            }

        }
        
        if(Input.GetMouseButtonUp(0))
        {
            dragObject = null;
        }

    }

    private void FixedUpdate()
    {
        if(dragObject)
        {
            marker.transform.position = Input.mousePosition + offset;

            Vector3 mousePositionOffset = Camera.main.ScreenToWorldPoint(new Vector3
            (Input.mousePosition.x,
                Input.mousePosition.y,
                selectionDistance)) - orginalPosition;

            dragObject.velocity = (orginalPosition + mousePositionOffset - dragObject.transform.position)
                                  * forceAmmount * Time.deltaTime;
        }
    }
}